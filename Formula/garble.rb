class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "11c038cb5fb6b21a2160305beec939c69b0712e39f52f0a0b6d977fa68d5b6db"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73907c284591a743abdf2d4f561e7b5d496250e5e03b5851201d67269e73e0ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73907c284591a743abdf2d4f561e7b5d496250e5e03b5851201d67269e73e0ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73907c284591a743abdf2d4f561e7b5d496250e5e03b5851201d67269e73e0ce"
    sha256 cellar: :any_skip_relocation, ventura:        "af879b7502518587d503004339f641f3586119f6b40937098a2df7c75a186fdd"
    sha256 cellar: :any_skip_relocation, monterey:       "af879b7502518587d503004339f641f3586119f6b40937098a2df7c75a186fdd"
    sha256 cellar: :any_skip_relocation, big_sur:        "af879b7502518587d503004339f641f3586119f6b40937098a2df7c75a186fdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fe89f012b56a10daed4211e299fa7e98bf1bb80ccacdadf5e0d8f33b4a60519"
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
