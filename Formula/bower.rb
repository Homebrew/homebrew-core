require "language/node"

class Bower < Formula
  desc "Package manager for the web"
  homepage "https://bower.io/"
  # Use Github tarball to avoid bowers npm 4+ incompatible bundled dep usage
  url "https://github.com/bower/bower/archive/v1.8.4.tar.gz"
  sha256 "ed4719fa1131dae285de3a013332756ec39f28bc38ec778bc777d74e935163c5"

  bottle do
    cellar :any_skip_relocation
    sha256 "02a7d64987c14db303484c1dc329f485ad9596726038bf30667f9f28e995a772" => :high_sierra
    sha256 "341e7e76f3536cb8b2ddbbcc4d2e96c004e76bced2d375a3c636914c0ec11fa2" => :sierra
    sha256 "58a39bd911c39d6e1d319fb94d6073b91566ff73f361cf41a9ee5006c546050e" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"bower", "install", "jquery"
    assert_predicate testpath/"bower_components/jquery/dist/jquery.min.js", :exist?, "jquery.min.js was not installed"
  end
end
