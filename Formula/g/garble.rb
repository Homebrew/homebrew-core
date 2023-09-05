class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "11c038cb5fb6b21a2160305beec939c69b0712e39f52f0a0b6d977fa68d5b6db"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68801fedbed69d7e0acc8bf6d7bc2d6ed580009f9d9cc9575cba3121ec08e3b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b18cb70aaecc39dd9eab835978136188226db620a8109a5fa22e486f36fe1398"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e732ee4ec2265028000152c1931cbc4adaaae2fa5bcb28cc49ec77f715666dc"
    sha256 cellar: :any_skip_relocation, ventura:        "d89fa84f9f985722ec2e989af7fa6da9a21c8d5345e203c9f5f61463beebf3dd"
    sha256 cellar: :any_skip_relocation, monterey:       "ca922c0f2e222c14d24b6cecf9e17b3eef23b309047119db76b1e61f874228a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fecd55a27e267e527f81dcba0db8c01b3df21ef368e96481923557926dca433"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3c546c33261a2e539609f6166c8772206a457450b6d369645707485828f09dc"
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
