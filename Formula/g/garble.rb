class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "11c038cb5fb6b21a2160305beec939c69b0712e39f52f0a0b6d977fa68d5b6db"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be1e80b3d0ebf286927d332ae2745be77cad58a69d99dad0cbc4da50db6fc9ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c15151f7fe6c99f6ab640bc9f7a475d93685257494297f81d55dc221eef56de2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f92ddfb8ab96fcf15da5550bd74c6d3094a923c2021751f6c1623094bb58425e"
    sha256 cellar: :any_skip_relocation, sonoma:         "c6493d1edf1fc58c1d78f2557b32e7d9024a48a42f22c58bf43da92fbb3e62a1"
    sha256 cellar: :any_skip_relocation, ventura:        "462f3f39132352b0be00bc1bc501b0444b0bfd054397c3fe0cccc8dc9a318719"
    sha256 cellar: :any_skip_relocation, monterey:       "2cc58a21cf914107986caed76056274a58353b5e0f17a6120c16acc1af129ad3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "227a1d707613a644d9f565ce0b80917b82db37b81758c0678ee507c0d7402c0c"
  end

  depends_on "go" => [:build, :test]
  depends_on "git"

  def install
    inreplace "internal/linker/linker.go", "\"git\"", "\"#{Formula["git"].opt_bin}/git\""
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"hello.go").write <<~EOS
      package main

      import "fmt"

      func main() {
          fmt.Println("Hello World")
      }
    EOS
    system bin/"garble", "-literals", "-tiny", "build", testpath/"hello.go"
    assert_equal "Hello World\n", shell_output("#{testpath}/hello")

    goos = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOARCH").chomp
    expected = <<~EOS
      Build settings:
            -buildmode exe
             -compiler gc
             -trimpath true
        DefaultGODEBUG panicnil=1
           CGO_ENABLED 1
                GOARCH #{goarch}
                  GOOS #{goos}
    EOS
    assert_match expected, shell_output("#{bin}/garble version")
  end
end
