require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.24.0.tgz"
  sha256 "fb04ab4e58bc8970934520d344b0cd74f7d6c59d84dd7a21466e5b44635cbb8e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "de55a9862cce781d0e593dba6379ec3bb1d1766dc8f4ef2d78633909b139ed5e"
    sha256 cellar: :any_skip_relocation, big_sur:       "704b45ace777d3c93537ca97399ac9a90d5e9d79f3d83ff6bed0a8e9524fdea9"
    sha256 cellar: :any_skip_relocation, catalina:      "3443c0f15a4314bf5753b4472c971ba9536fda8c524205a4733d0c7ffd03c42c"
    sha256 cellar: :any_skip_relocation, mojave:        "49a324c1b0898ca06636ac992772a8aafcd907d02a16738b61f601485cbef502"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a5ef99229d9942afc91a0336d545642ca1e4896cb7a998f75d3a93703a54365"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.write_exec_script libexec/"bin/ask"

    term_size_vendor_dir = libexec/"lib/node_modules/#{name}/node_modules/term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries

    on_macos do
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir
    end
  end

  test do
    output = shell_output("#{bin}/ask deploy 2>&1", 1)
    assert_match "[Error]: CliFileNotFoundError: File #{testpath}/.ask/cli_config not exists.", output
  end
end
