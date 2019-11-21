require "language/node"

class NowCli < Formula
  desc "The command-line interface for Now"
  homepage "https://zeit.co/now"
  url "https://registry.npmjs.org/now/-/now-16.6.0.tgz"
  sha256 "003cada057ac38323127014eea38e92d158755c65f276243d6613add51c8be46"

  bottle do
    cellar :any_skip_relocation
    sha256 "07a43e34820deb98cf9e923da48f9272ff96c3547da8994027015c29cf87e33c" => :catalina
    sha256 "ba8f3b189631b4e89eaf9e87a1332e496cb1e5e27d94a2446741809ff06aceed" => :mojave
    sha256 "87d0f6f17d4185b63e71332de75a2568c18c2799de6515f2c54f972181ef846d" => :high_sierra
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
