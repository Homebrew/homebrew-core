class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "0eb231e6ad91793f0fcf086fb57a1654f0c2056284a79fb12ac955ade6791737"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4a08c083cc0d9d8ff3d26f6e005bfd862f65ae9c72015396dfd8974019026ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4a08c083cc0d9d8ff3d26f6e005bfd862f65ae9c72015396dfd8974019026ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4a08c083cc0d9d8ff3d26f6e005bfd862f65ae9c72015396dfd8974019026ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "0854b508b874b0a6219f6932235f1d82ad9cca72f0e294ca4892eaa6c7cb48da"
    sha256 cellar: :any_skip_relocation, ventura:       "0854b508b874b0a6219f6932235f1d82ad9cca72f0e294ca4892eaa6c7cb48da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e1c4a494f23c2e7527963161de1936ad580c8945587597cff9ab465064453e5"
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
