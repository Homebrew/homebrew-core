class Gravity < Formula
  desc "Embeddable programming language"
  homepage "https://www.gravity-lang.org/"
  url "https://github.com/marcobambini/gravity/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "a6c8894276d4f1cc3bd4014bfd666a2f1ee715539d4de55db456f8af0db2ee34"
  license "MIT"
  head "https://github.com/marcobambini/gravity.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae67db26634831433bd90de691330a850e6f46f39ea41a201e4238521881bd53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fa5c2be5512fd88981b92569679c5ff1f1e5a6985bb50d079ed9294923a64b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9020f305ac3fc5ee9a6853f9e299d0c61ec5d0f50d2021bc106c2eea788e427"
    sha256 cellar: :any_skip_relocation, sonoma:        "814fbfdf25654d7c5341471be9a0a81c6784ffa68f0223a542b9be59b9180b5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f071c9128cb1c9625f914efef9ca0d1722f8b6b37a94f8301b705ce97864b0b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "355c05f2f06e99c8a2445b8094d435bfe2b1b060c1abdca9c05780703d91623b"
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
