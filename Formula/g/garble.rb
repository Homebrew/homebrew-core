class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "98ade316176d434f298bdb36e4c421e3c4c33668cfd2922d358f7f0403566500"
  license "BSD-3-Clause"
  revision 6
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad9d97457e74c332d0b396104fd06bdfb45a575b948cebebd2d1b906f8781577"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0710bb8adb3e41b132db1a95d2e6ff48ed9ca366b8e3eb256bcf55f33e28936"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7bf92f187d254443ed06f383f677870d2d10d699bd7e06d24735f8ff75e8c57"
    sha256 cellar: :any_skip_relocation, sonoma:         "98073a96ccd345437b5cab868fda304e1e6dcaa3457ef75165b89e07687de003"
    sha256 cellar: :any_skip_relocation, ventura:        "c57dcbed5a389285bbcd71891d86844ecf94deed27c334d18e688302e07276ba"
    sha256 cellar: :any_skip_relocation, monterey:       "e3af2f15ee584c8272750c699fa4423a37fc328bd46027651645ce788ea645ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99293abbb6731948f9fd9d8166e03dc26f964b343b34ba5701b2a4ff01818ce0"
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
