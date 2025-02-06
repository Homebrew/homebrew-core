class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "9fb75bad82fc89afe08bbdb26c9bbbba8766a1663f8bb585318cf363fd3eedbf"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9abc206d2d2b7eb241c831f4c747c3751cbf0889a55a5f8c43035597dcdfaa6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9abc206d2d2b7eb241c831f4c747c3751cbf0889a55a5f8c43035597dcdfaa6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9abc206d2d2b7eb241c831f4c747c3751cbf0889a55a5f8c43035597dcdfaa6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccb7bd3ccd7f7b6f72ed7d83be99078b881a4afb7640120e05046e7eb04a4215"
    sha256 cellar: :any_skip_relocation, ventura:       "ccb7bd3ccd7f7b6f72ed7d83be99078b881a4afb7640120e05046e7eb04a4215"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bf42f55a4caabbf26e018ee60d7eb8333fb7a51b490cc1b65d6d50169b062e7"
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
