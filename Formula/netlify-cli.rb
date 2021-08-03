require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-5.4.10.tgz"
  sha256 "9769c561a62bf5a5b2b70c4bd34eb389122c4c9849c3e5a3966bba1baa4dba6c"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a7a8dfd62409c59f866210166d1a3fa50dd51ae3b4da26c776b38997ea2e18ab"
    sha256 cellar: :any_skip_relocation, big_sur:       "1244f0e29f4d2f8e3536f98d59620b62e3c01f808e6758ae9f1559f93ab782e3"
    sha256 cellar: :any_skip_relocation, catalina:      "1244f0e29f4d2f8e3536f98d59620b62e3c01f808e6758ae9f1559f93ab782e3"
    sha256 cellar: :any_skip_relocation, mojave:        "1244f0e29f4d2f8e3536f98d59620b62e3c01f808e6758ae9f1559f93ab782e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9dcc32c932e9959dff9a8fea679d36344f96059113ea86959f5bdb701d717b1"
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
