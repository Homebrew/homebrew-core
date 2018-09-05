require "language/node"

class Alexjs < Formula
  desc "Catch insensitive, inconsiderate writing"
  homepage "https://alexjs.com"
  url "https://github.com/wooorm/alex/archive/6.0.0.tar.gz"
  sha256 "9680901254fc41f3c1bd36505cc7c2e82682ae023058e49bbf539ebe77e93f41"

  bottle do
    cellar :any_skip_relocation
    sha256 "a73abe634cca6ab63b5bba0158773097cdc91b3bcd89e2199714afb69e1bf393" => :mojave
    sha256 "63837a78ef2e29112d814512c5cc1e2f4f84838755a48282818d524a2163b510" => :high_sierra
    sha256 "57ec3f1ac7588459ee8f169dcef16fa9e89154a32b12c4bdf4d668e0d2fa2b84" => :sierra
    sha256 "80725e1dba5b2ffa15bf1efb55e65f8098f827ae6c3edefadfa0b4f1d1bb373b" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.txt").write "garbageman"
    assert_match "garbage collector", shell_output("#{bin}/alex test.txt 2>&1", 1)
  end
end
