require "language/node"

class NowCli < Formula
  desc "The command-line interface for Now"
  homepage "https://zeit.co/now"
  url "https://registry.npmjs.org/now/-/now-17.0.4.tgz"
  sha256 "f8009a78b1589b1df2a14b23dab79a7c2924d999a4389175a91bc3e6811cab19"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8796c55cae1e32fde54e42b91998ee45aab95ad057fe591ffa549746d65b82c" => :catalina
    sha256 "306f8f80edb74f63c36ac8d1597b12b036d456e5e4f1c2923aebefbf49ad92a4" => :mojave
    sha256 "6ff6ed31e5e9a41c6eb5788787b140c506712ba9b59796a058d4346b2ba8fdcf" => :high_sierra
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
    system "#{bin}/now", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
