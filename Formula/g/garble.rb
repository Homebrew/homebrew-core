class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "b429b24dafa851a25bbeca635db33eb4162b8e3109fb234a2c8e7780a837b958"
  license "BSD-3-Clause"
  revision 4
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b63963d1cf9d5d5c7a493fae78496623337df6378c0fec2776a85c5c8a3111da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b63963d1cf9d5d5c7a493fae78496623337df6378c0fec2776a85c5c8a3111da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b63963d1cf9d5d5c7a493fae78496623337df6378c0fec2776a85c5c8a3111da"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc68af1371aaf89e5f85ce2e5a9949629acbda6271cea3c38c31f6545d42fdd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f81db4409934a5cc26ea1c9e3308f41ca1336d0455fb21ff36a96412492e7e0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56885a7d6b4597fcd29339cde7bebd7ea149de9a269338ff63a7033c379aca4e"
  end

  depends_on "go" => [:build, :test]
  depends_on "git"

  def install
    inreplace "internal/linker/linker.go", "\"git\"", "\"#{Formula["git"].opt_bin}/git\""
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"hello.go").write <<~GO
      package main

      import "fmt"

      func main() {
          fmt.Println("Hello World")
      }
    GO
    system bin/"garble", "-literals", "-tiny", "build", testpath/"hello.go"
    assert_equal "Hello World\n", shell_output("#{testpath}/hello")

    expected = <<~EOS
      Build settings:
            -buildmode exe
             -compiler gc
             -trimpath true
    EOS
    assert_match expected, shell_output("#{bin}/garble version")
  end
end
