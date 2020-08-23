class Gravity < Formula
  desc "The Gravity Programming Language"
  homepage "https://marcobambini.github.io/gravity/"
  url "https://github.com/marcobambini/gravity/archive/0.7.8.tar.gz"
  sha256 "d6589e1cf55eb3b46e205342cb8c01d524da66b98b6fabe0785c711ec314969d"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "a98efa44c0d6442beabb0b95efb8d404d81b982d5f6cd41225bbf64dede0f5be" => :catalina
    sha256 "05f4fba3adf2677631c67980a296f0d43c733221532853f42daef08348627bcb" => :mojave
    sha256 "3ee168dfc2cf1397868dbd520bf2b89f04286394f354a86dad602e58c4d9f15a" => :high_sierra
  end

  def install
    system "make"
    bin.install "gravity"
    doc.install Dir["docs/*"]
  end

  test do
    (testpath/"hello.gravity").write <<~EOS
      func main() {
          System.print("Hello World!")
      }
    EOS
    system bin/"gravity", "-c", "hello.gravity", "-o", "out.json"
    assert_equal "Hello World!\n", shell_output("#{bin}/gravity -q -x out.json")
    assert_equal "Hello World!\n", shell_output("#{bin}/gravity -q hello.gravity")
  end
end
