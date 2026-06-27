class Gravity < Formula
  desc "Embeddable programming language"
  homepage "https://www.gravity-lang.org/"
  url "https://github.com/marcobambini/gravity/archive/refs/tags/0.9.7.tar.gz"
  sha256 "6f75b995402fa0140e6d9b594c632ef145c1ff7ba80b4e5b65106117fc41984c"
  license "MIT"
  head "https://github.com/marcobambini/gravity.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec3b9d10debd6c9f7b62da13d8124b02ab09b1f58e35b782d60f7e4a333fc015"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a924f86ec2a85e9ba98bac33cbcb2d3f95c0d25d88115201e2991687a8f2ae88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6be75446aee6c6e9cd38d53167ec2840d58e769fbf393cb83bd052e35dc67672"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ef792c2081eb85678cb13a6ba65cf79ffacc1f692b879ee21007b5ec9be97f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6dfe83f37ff00cba154e21b4fd3f732d370d29521e31251b7cae233f9dd21594"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20472b64ad64254ef6719332320a93571814d1bc5b757da4ed94bda57da0bedc"
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
