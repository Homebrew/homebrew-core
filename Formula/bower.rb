require "language/node"

class Bower < Formula
  desc "Package manager for the web"
  homepage "https://bower.io/"
  # Use Github tarball to avoid bowers npm 4+ incompatible bundled dep usage
  url "https://github.com/bower/bower/archive/v1.8.8.tar.gz"
  sha256 "3faf6c6ba0f96a8ee7ca7329911e683131198cbdd9a25ee4976b46f90357d481"

  bottle do
    cellar :any_skip_relocation
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
