require "language/node"

class NowCli < Formula
  desc "The command-line interface for Now"
  homepage "https://zeit.co/now"
  url "https://registry.npmjs.org/now/-/now-16.6.0.tgz"
  sha256 "003cada057ac38323127014eea38e92d158755c65f276243d6613add51c8be46"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a84aaf3de2fc102a50dfa5501d72d8eb6888ad4a268011829a38daa348607e6" => :catalina
    sha256 "8cddeba4c6fe47a19f3b42f04c189b23c48ecef756bfdd5adec3f712653d7cb1" => :mojave
    sha256 "d047c596e4b44869a1731054847c165d6a90e4840bb348e5610dfaed5bc0b26f" => :high_sierra
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
