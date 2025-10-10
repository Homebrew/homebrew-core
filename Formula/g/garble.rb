class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "b429b24dafa851a25bbeca635db33eb4162b8e3109fb234a2c8e7780a837b958"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dca149aa49d2190f405e83f6fb513646045c5d37013c15e856e38952adc04d8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dca149aa49d2190f405e83f6fb513646045c5d37013c15e856e38952adc04d8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dca149aa49d2190f405e83f6fb513646045c5d37013c15e856e38952adc04d8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8fc0e7a8e7041ff0b4b654c5a05d9acdb0cbd1be73c01dfe9013997d6f22d640"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03275553286d7a4a77e37585d4cfb5a1965f86b63374cc624970e3e35298de1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc806bf1e6ded5ecba0d4538285904c6e5fdaf94a892fe9d8df4592bcc23dacc"
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
