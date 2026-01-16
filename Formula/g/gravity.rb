class Gravity < Formula
  desc "Embeddable programming language"
  homepage "https://www.gravity-lang.org/"
  url "https://github.com/marcobambini/gravity/archive/refs/tags/0.8.5.tar.gz"
  sha256 "5ef70c940cd1f3fec5ca908fb10af60731750d62ba39bee08cb4711b72917e1d"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "c40e91f9e2727a8fa187420366de0aa3477cd0826810c493badfebcbbb642689"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3b9deeeaa076effc41b7d65f16d152e75895327bb4692061afc8b86acc5c25fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1938bccfa92b1139af3b20ffd2acab61f7860bfaa0a08ddb233b365db300e59c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3e27f2ccdad0ad0ea5b4c51406aa149a830647be7746fc5a331aa55ac537be8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd8ad02be9b28d88e59d71b34ec0e57e11f8647654de9787a01529ab2740f527"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45bbef2a6a44492360953457a4bcedc14d5158d5ae654dac143d4acf6a0ceccd"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea10a43302c779b73aa7480c707b0b76a51582a9b17b81ffb912ba447ab4aec3"
    sha256 cellar: :any_skip_relocation, ventura:        "31be6d870c1a1def84a678ffc2201d2a846eabf208aaad97ffca0e6065a72f26"
    sha256 cellar: :any_skip_relocation, monterey:       "106785af925ee88415030eede30c8eadc5cdd590cdfdf992d8c2d3ea4fb7ae27"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3ac70acf8c191279d44ca6ee217677922dbbebd47ce4aeafb08279e25a54c58"
    sha256 cellar: :any_skip_relocation, catalina:       "e8babf831217e11680298ae3fc6eb6881b01b99abe01c37c6cd98ad57a63747f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9cc9fc83af4291367585c6525a894449010981db51f9bcd7162635e1b0cd21f2"
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
