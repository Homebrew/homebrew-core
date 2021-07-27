require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-5.2.10.tgz"
  sha256 "73b92fb9333c9cf67ef9669b789bc30e10cd6d13a5a774e1d732ee7ce0d93be5"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2ccd8fa32ff276c8c98cd7ce47ff2531a493e2f6083ac80e40e1f760e5db3faa"
    sha256 cellar: :any_skip_relocation, big_sur:       "9a1144d6d89a527e6adebc8e09a579582fe8adaaf9535574a5888f226638eabd"
    sha256 cellar: :any_skip_relocation, catalina:      "9a1144d6d89a527e6adebc8e09a579582fe8adaaf9535574a5888f226638eabd"
    sha256 cellar: :any_skip_relocation, mojave:        "9a1144d6d89a527e6adebc8e09a579582fe8adaaf9535574a5888f226638eabd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd6c03afa17ab1d6c1045a8195bc5567de24c80ab1f5be529cbcbef69c6be815"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

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
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/netlify login
      expect "Opening"
    EOS
    assert_match "Logging in", shell_output("expect -f test.exp")
  end
end
