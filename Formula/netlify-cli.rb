require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.24.0.tgz"
  sha256 "3e8e49989ca275bb9ae55e7cfefc17bc7f60d6be9c8e412cf1d480d717c44b15"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e866cfb6dde44f235ffffb1714b10ccb6c2dc55e63918572ca286a5c57353da0" => :catalina
    sha256 "896d5e2393beca25887bfae12d17a3cbab4a8138c88a4a043ba9bd26d155eaac" => :mojave
    sha256 "ce6132533e9f373d28ccbeed602576a708a444dc13c994da1fa5b0a07605cea4" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/netlify login
      expect "Opening"
    EOS
    assert_match "Logging in", shell_output("expect -f test.exp")
  end
end
