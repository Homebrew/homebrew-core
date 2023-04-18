class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "26e001eb469c9357c2a5212ee295da3c588b7f36b1ce0b7e7b92b8e6d44f0cd1"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6171bb8f92a3826195abff015480e03707d1e77def50f851d227eb16dacf2884"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6171bb8f92a3826195abff015480e03707d1e77def50f851d227eb16dacf2884"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6171bb8f92a3826195abff015480e03707d1e77def50f851d227eb16dacf2884"
    sha256 cellar: :any_skip_relocation, ventura:        "c31c0d483fddba749eb99995d9174bb46295767a52d861779bb26782041a4765"
    sha256 cellar: :any_skip_relocation, monterey:       "c31c0d483fddba749eb99995d9174bb46295767a52d861779bb26782041a4765"
    sha256 cellar: :any_skip_relocation, big_sur:        "c31c0d483fddba749eb99995d9174bb46295767a52d861779bb26782041a4765"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cac230c6184cdeb654e51d24712c3bc76eb95b8e229475198fd4dc1310c65e45"
  end

  depends_on "go" => [:build, :test]

  def install
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
           CGO_ENABLED 1
                GOARCH #{goarch}
                  GOOS #{goos}
    EOS
    assert_match expected, shell_output("#{bin}/garble version")
  end
end
