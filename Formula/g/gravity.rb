class Gravity < Formula
  desc "Embeddable programming language"
  homepage "https://www.gravity-lang.org/"
  url "https://github.com/marcobambini/gravity/archive/refs/tags/0.9.0.tar.gz"
  sha256 "c3bf1dfa9b881bcdbc259102b9997dec7289e18663f51103de673826783cea66"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "984f8c939ed835a4b7d3cf1ca27a3cc0563b13a665da1ce73aa7897104a3b943"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "187fb5a7dffad37011e777b898c6e27d4b923a004c2371ae24f8db2aece2c1dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35f67b6a4bd03c684deda21c05d2226765b99a469694f0b36495af7eee958573"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ef561c3f244eaa3f14501ae3dffd88817d59956d6aff96625e440f23feb3c60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9eae21c4d214e2e15fa324f8a3c91fbb2317449697f4bef9d418bc513f86248"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15d21ad9f8233f3aa519c43b28d395d2a12ed80fa4f8427cd55cae23de28338f"
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
