require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.24.1.tgz"
  sha256 "b3d489f5aaba8f845478f53540bf98b10b0b12b9a45049b32d7dba103942614e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "11200df13cd54f880bfb56c32e9755238b532b921b8ecc9d4480e59639bf94dd"
    sha256 cellar: :any_skip_relocation, big_sur:       "aeb503480c9ad02e578bb293ff74a767c52f1e40b273db7b42b37c27f447cded"
    sha256 cellar: :any_skip_relocation, catalina:      "5d27e0fa08d8818ae2e846c24da5a12d740155f7c11214b674ef3c5f985fa860"
    sha256 cellar: :any_skip_relocation, mojave:        "bdc70b5a79ef6780c754ba14bba066479fdb9bd1a6806b454e2eb9cf868d89ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab907aa1e0faca07c18a05a9e811dab6d1b0ee1ed0464fd405dda4cc22ee5b85"
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
