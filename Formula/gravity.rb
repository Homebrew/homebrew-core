class Gravity < Formula
  desc "Embeddable programming language"
  homepage "https://marcobambini.github.io/gravity/"
  url "https://github.com/marcobambini/gravity/archive/0.8.3.tar.gz"
  sha256 "b35f3f8a82f508be3bb3b746c5b1b9bb924171ea110480a209bce4ca4a9d5539"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "85ef605bd023af84e0db85b35c75cba699b168d9c5f21ab8d5346716060228af"
    sha256 cellar: :any_skip_relocation, big_sur:       "49f19ce7992a5e087b879beaf9a4a8fb875a0d063b283e5aadfc320cb2b41f79"
    sha256 cellar: :any_skip_relocation, catalina:      "73e493759b7928d8a557fb194f3fd4b9d4b700fcc2fdb85953f273f68350e31d"
    sha256 cellar: :any_skip_relocation, mojave:        "1ad9606bdd5ff83b24b1220cdde9adfa70ff2b92c887d5cf4a67141cfd1e24c4"
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
