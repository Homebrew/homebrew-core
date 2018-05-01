require "language/node"

class Bower < Formula
  desc "Package manager for the web"
  homepage "https://bower.io/"
  # Use Github tarball to avoid bowers npm 4+ incompatible bundled dep usage
  url "https://github.com/bower/bower/archive/v1.8.4.tar.gz"
  sha256 "ed4719fa1131dae285de3a013332756ec39f28bc38ec778bc777d74e935163c5"

  bottle do
    cellar :any_skip_relocation
    sha256 "359ec9939072dd0feed1a6e7409e2d4e37412753c63cc6b04ef85c536b89c0a7" => :high_sierra
    sha256 "9620d23985975efe543f6d6fcdcbb13bc2f1d439184f9ef05104437425714665" => :sierra
    sha256 "19d149753affff318a3923ee83c93589d887140d51e667d6a11ddeeaa3f19c5f" => :el_capitan
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
