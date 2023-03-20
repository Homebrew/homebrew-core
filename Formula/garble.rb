class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "26e001eb469c9357c2a5212ee295da3c588b7f36b1ce0b7e7b92b8e6d44f0cd1"
  license "BSD-3-Clause"
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2749498749a5db85febca9b6ec5fed5a05f3abfe4d09f13972addae9092dab0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2749498749a5db85febca9b6ec5fed5a05f3abfe4d09f13972addae9092dab0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2749498749a5db85febca9b6ec5fed5a05f3abfe4d09f13972addae9092dab0"
    sha256 cellar: :any_skip_relocation, ventura:        "26e6c5a71f0ef051a6b2d0c032baf1d6f8de627311e33208833f60bfe5b10b4e"
    sha256 cellar: :any_skip_relocation, monterey:       "26e6c5a71f0ef051a6b2d0c032baf1d6f8de627311e33208833f60bfe5b10b4e"
    sha256 cellar: :any_skip_relocation, big_sur:        "26e6c5a71f0ef051a6b2d0c032baf1d6f8de627311e33208833f60bfe5b10b4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b23bedfb5d02de1158cdc773edbb9409ccda7c6307758835e8db0e190f7bd82d"
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
