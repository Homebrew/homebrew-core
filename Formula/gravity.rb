class Gravity < Formula
  desc "Embeddable programming language"
  homepage "https://marcobambini.github.io/gravity/"
  url "https://github.com/marcobambini/gravity/archive/0.8.5.tar.gz"
  sha256 "5ef70c940cd1f3fec5ca908fb10af60731750d62ba39bee08cb4711b72917e1d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3e27f2ccdad0ad0ea5b4c51406aa149a830647be7746fc5a331aa55ac537be8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd8ad02be9b28d88e59d71b34ec0e57e11f8647654de9787a01529ab2740f527"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45bbef2a6a44492360953457a4bcedc14d5158d5ae654dac143d4acf6a0ceccd"
    sha256 cellar: :any_skip_relocation, ventura:        "31be6d870c1a1def84a678ffc2201d2a846eabf208aaad97ffca0e6065a72f26"
    sha256 cellar: :any_skip_relocation, monterey:       "106785af925ee88415030eede30c8eadc5cdd590cdfdf992d8c2d3ea4fb7ae27"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3ac70acf8c191279d44ca6ee217677922dbbebd47ce4aeafb08279e25a54c58"
    sha256 cellar: :any_skip_relocation, catalina:       "e8babf831217e11680298ae3fc6eb6881b01b99abe01c37c6cd98ad57a63747f"
    sha256 cellar: :any_skip_relocation, mojave:         "f3bf9cf96f56a2c11ce36ffe28e68ff1695b4b04432fbfe8a2ddcbc4df17ff43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86f00ccfa0552e839135dc94c541c791c3562d70b306dab42eee8e3e0762df9b"
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
