class Gravity < Formula
  desc "Embeddable programming language"
  homepage "https://www.gravity-lang.org/"
  url "https://github.com/marcobambini/gravity/archive/refs/tags/0.9.8.tar.gz"
  sha256 "7340092fb4b66a9ebda721cae39324422612d1b969ba70fee8eb7664951cdd80"
  license "MIT"
  head "https://github.com/marcobambini/gravity.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40e6195395a39194489bb924a06e71b1e4aa82c27899acac3d89a649369be587"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec721baa0abcf011583415394ba15e9fb745df30702b358c5e835bc51bc18796"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fe303f1bbcfb030835a83673042ea2d137dd5fae65ee89bff2fd8b9e1e8e44c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c43a4dc57ae4046a8c38dacdb28017db9aed7d4951915e60ca658161a5a3f972"
    sha256 cellar: :any,                 arm64_linux:   "e9328e3f108e8701508f6cbf00740007d2810943a15b1d38faaea718c52912f9"
    sha256 cellar: :any,                 x86_64_linux:  "9f4f73c711cd472694e4bcc9353bff95f05670c1011d799ce2d38971b1c66aea"
  end

  def install
    system "make"
    bin.install "gravity"
    doc.install Dir["docs/*"]
  end

  test do
    (testpath/"hello.gravity").write <<~GRAVITY
      func main() {
          System.print("Hello World!")
      }
    GRAVITY
    system bin/"gravity", "-c", "hello.gravity", "-o", "out.json"
    assert_equal "Hello World!\n", shell_output("#{bin}/gravity -q -x out.json")
    assert_equal "Hello World!\n", shell_output("#{bin}/gravity -q hello.gravity")
  end
end
