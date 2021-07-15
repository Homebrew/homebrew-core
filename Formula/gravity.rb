class Gravity < Formula
  desc "Embeddable programming language"
  homepage "https://marcobambini.github.io/gravity/"
  url "https://github.com/marcobambini/gravity/archive/0.8.3.tar.gz"
  sha256 "b35f3f8a82f508be3bb3b746c5b1b9bb924171ea110480a209bce4ca4a9d5539"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e4bbcd21021ce0ea675f4e89eb7ee5e7891a76329397045f391c1fc66fc29ac6"
    sha256 cellar: :any_skip_relocation, big_sur:       "45fa429c501fbc6bed4df03f4bd42d843eb9a0c2178c38e91463c5be23d8c559"
    sha256 cellar: :any_skip_relocation, catalina:      "b5c92698d98471fd098e09fafbc39cfac3fbde7f445e5fadde854fab8aa8f658"
    sha256 cellar: :any_skip_relocation, mojave:        "dca9c51bdb7adbc1310c28ac630b19f12567d3110af64a7a0e4821ea61c31e8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6aeb751341c9fa47021bf5c3813ad437f1d745958e83b2a80596a9154f28633c"
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
