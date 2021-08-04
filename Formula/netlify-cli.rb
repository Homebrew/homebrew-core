require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-6.0.0.tgz"
  sha256 "82efb002b2b0fe052bc62c00a371d3f4714e1677d791ed56c5ebea5eb9b1b339"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8524d5660db2716900b0dce74f80ed46af101cd938b02c15a34addfe3f26cdc5"
    sha256 cellar: :any_skip_relocation, big_sur:       "0707d6fcb02cbd1528f13ba93a6a3bdae54325bf653b03be97f4f9711cb1fcdb"
    sha256 cellar: :any_skip_relocation, catalina:      "0707d6fcb02cbd1528f13ba93a6a3bdae54325bf653b03be97f4f9711cb1fcdb"
    sha256 cellar: :any_skip_relocation, mojave:        "0707d6fcb02cbd1528f13ba93a6a3bdae54325bf653b03be97f4f9711cb1fcdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99dba28774b64ebf14ac5a07c7a741133c15b5c16d5514b3bfa1c9589c29aac6"
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
