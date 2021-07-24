require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-5.2.0.tgz"
  sha256 "6be3d3c2c84d0320ab106eeb221ae82f11479233c0cc6466bd987c6310b0778e"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1ee2ee21bea0cdf4cf519254f150ef0ff19f325ecdaa501c9aae8152e0315859"
    sha256 cellar: :any_skip_relocation, big_sur:       "afbd21084ce4a63f872dfe8d52d61dd3f9b31aea3d74c4eeb3ec4abc76626d31"
    sha256 cellar: :any_skip_relocation, catalina:      "afbd21084ce4a63f872dfe8d52d61dd3f9b31aea3d74c4eeb3ec4abc76626d31"
    sha256 cellar: :any_skip_relocation, mojave:        "afbd21084ce4a63f872dfe8d52d61dd3f9b31aea3d74c4eeb3ec4abc76626d31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6529a2af5e494ac29086bfe9dfdf70218b0d793767beae4df368476233e153ed"
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
