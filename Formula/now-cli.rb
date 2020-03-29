require "language/node"

class NowCli < Formula
  desc "The command-line interface for Now"
  homepage "https://zeit.co/now"
  url "https://registry.npmjs.org/now/-/now-17.1.0.tgz"
  sha256 "b440d27e89d77281a8fc980a72f87422e8b0c24779ae1fbed5f13fe21b70cb8c"

  bottle do
    cellar :any_skip_relocation
    sha256 "7f4f7f1d8f6344c07cceb7e321697fd512485e0906fbe8aaf227326a9b5c48ff" => :catalina
    sha256 "08ba1fd3d08195f546d6f537fc1ee749a03165f92f8329a6daa55ee1780bfc5e" => :mojave
    sha256 "46d102c84bfbb066b77e71c54b13e54b9dec7ab03fb710ba34a91b67cd95390f" => :high_sierra
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
