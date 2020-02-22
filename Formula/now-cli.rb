require "language/node"

class NowCli < Formula
  desc "The command-line interface for Now"
  homepage "https://zeit.co/now"
  url "https://registry.npmjs.org/now/-/now-17.0.4.tgz"
  sha256 "f8009a78b1589b1df2a14b23dab79a7c2924d999a4389175a91bc3e6811cab19"

  bottle do
    cellar :any_skip_relocation
    sha256 "45f1e5824f5555555424790d0b8972c72410fa9c85477a3354345e967d8df71a" => :catalina
    sha256 "cafb73b9c9fdca3a66603a868ba074cc95cadb6f76a8f355fc7e5c585aa8a61d" => :mojave
    sha256 "b88e5182fd84420dfcc198c026f8c5c032204df0b307f7264ddaae565d6a82bb" => :high_sierra
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
