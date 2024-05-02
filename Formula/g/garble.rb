class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "98ade316176d434f298bdb36e4c421e3c4c33668cfd2922d358f7f0403566500"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19161c6b57a5f5c11990e8da985b03787bec71a4c8271ac9c5df5dd461a9d7e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76123ca5eb93aa7752e793a4ca02c8bc8bccbe9033a9b615b4812d3d82b4b548"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7dab72f064da1b20e229a85d23c52c935d600f8d132a129e2a1c710f1a2f8d2f"
    sha256 cellar: :any_skip_relocation, sonoma:         "6883d82577effa967a4ecd0fa0fc1036f3545bbe66a26a9bc105f119c2384874"
    sha256 cellar: :any_skip_relocation, ventura:        "85fd38f005d2aac062ff1956cddd63f12208a0f38e72234c2d1f0ed5f1ccf0c7"
    sha256 cellar: :any_skip_relocation, monterey:       "0561c74881cf3df436c3d6b16567586c66f6bc5419be6152330e21611a5335ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "866bf95623de3b93fcbba40353b758e25d6cc561fb78eab73e457c08aeb2cf26"
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

    expected = <<~EOS
      Build settings:
            -buildmode exe
             -compiler gc
             -trimpath true
    EOS
    assert_match expected, shell_output("#{bin}/garble version")
  end
end
