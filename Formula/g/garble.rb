class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "11c038cb5fb6b21a2160305beec939c69b0712e39f52f0a0b6d977fa68d5b6db"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01a82650c8f492bed0d462843d5b00646b8608ee4deec0f675fe32f7b3761d39"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3bd69f0a95847a1bea02ccfe38367e3e1a1e972a5dfd0dfd2111c71f79cb595"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d3c7004197c4717a788da9c9571b1d33d9999eff748a555ee941b2c441f346f"
    sha256 cellar: :any_skip_relocation, ventura:        "1ee2ccb70d6a51818d50c3723e80f8e7f93f9c91051802e3d7c022b5f0ddfca3"
    sha256 cellar: :any_skip_relocation, monterey:       "6d362bbdd8fe0faaa0d1d207fa8030eb7674cfb19f93ec7fab11063c95d21547"
    sha256 cellar: :any_skip_relocation, big_sur:        "5eace665c9c26432203a608fb09f43171839b1673ff43ebbbb7744193824e736"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15458945d97a0e86f9123f3398a1d7fb71d7baa9f4755221a52519f67f3cbbbc"
  end

  depends_on "go" => [:build, :test]
  depends_on "git"

  def install
    inreplace "internal/linker/linker.go", "\"git\"", "\"#{Formula["git"].opt_bin}/git\""
    system "go", "build", *std_go_args
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
