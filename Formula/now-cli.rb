require "language/node"

class NowCli < Formula
  desc "The command-line interface for Now"
  homepage "https://zeit.co/now"
  url "https://registry.npmjs.org/now/-/now-16.4.1.tgz"
  sha256 "8eee26ccae7eded0833026640a8775907f792e33dfc38b3f631e7260c6724122"

  bottle do
    cellar :any_skip_relocation
    sha256 "90b5cf119eee772be637acb3e0000df6ae6851e0721ec3021c1d3330c6fae115" => :catalina
    sha256 "0b4d1bddd5e4f0b67478c4d4251bfa07e82cb0e45d8479dada60fad648d935f8" => :mojave
    sha256 "0a6512f9eec2ba909b1f43f417a96150b63a19e73f73692935b6623f8413c428" => :high_sierra
  end

  depends_on "node"

  def install
    rm Dir["dist/{*.exe,xsel}"]
    inreplace "dist/index.js", "t.default=getUpdateCommand",
                               "t.default=async()=>'brew upgrade now-cli'"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/now", "init", "markdown"
    assert_predicate testpath/"markdown/now.json", :exist?, "now.json must exist"
    assert_predicate testpath/"markdown/README.md", :exist?, "README.md must exist"
  end
end
