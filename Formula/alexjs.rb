require "language/node"

class Alexjs < Formula
  desc "Catch insensitive, inconsiderate writing"
  homepage "https://alexjs.com"
  url "https://github.com/get-alex/alex/archive/9.0.1.tar.gz"
  sha256 "b4e70076c14c52ef275abadc6c32fccdd28db31153b26ce0731b926c5014865e"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "c97b56b8dd8aeedab87b75fa7a68e5890e37143c5535558f0c3c260799e4e072" => :catalina
    sha256 "360af1b90a96be698e4f7228f4ab415c6b67e312ad68249da35c43cfd3535e82" => :mojave
    sha256 "b3c18e3c2dc317a481198ede983b12880d9a15cb31a0f7e249a6006b5eed8abc" => :high_sierra
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
