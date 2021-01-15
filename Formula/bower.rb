require "language/node"

class Bower < Formula
  desc "Package manager for the web"
  homepage "https://bower.io/"
  # Use Github tarball to avoid bowers npm 4+ incompatible bundled dep usage
  url "https://github.com/bower/bower/archive/v1.8.10.tar.gz"
  sha256 "1485f6b216cde0e156dc22b576ebcf895b3088930393967c26f5bc30a1ac624a"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "1c12654ea37e771168b7bf3c9d0efb25f2fd0c7690e44f1d8d4630a7625787cf" => :big_sur
    sha256 "b45fd2adcc3c01ac396f1a426301d957bde7cc2ad22ea0e4bb068fa12bc16087" => :arm64_big_sur
    sha256 "a93aa8f191f1c92fd1ff913baa979ba8f05c151ee488019e54179b38b7568888" => :catalina
    sha256 "82494967ba46ded634fb761e4fb166ab1d27605ba7514c4248ada0a00b1ce0cd" => :mojave
    sha256 "077291dbebb25e070a3387fb9e38f3400a35d1551fbf97936643061be4d522b3" => :high_sierra
    sha256 "2a5689573d8841a0ce8be340aea74f0585c3537340f9d53746fefd21cada43f5" => :sierra
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
