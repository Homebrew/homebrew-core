class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "98ade316176d434f298bdb36e4c421e3c4c33668cfd2922d358f7f0403566500"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a19a01c3edc28041725f1c68dc3d4e4a754bba36088990a22902248b09dd9152"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99f5e12998fa6486d3fac3d9352fd0134d6a0c4d8bab2c5e1240b3d9c7b8a264"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "934e882c51e814c101f4f9e51a3d7f39acce33bb288ce25692054675b2ad0e45"
    sha256 cellar: :any_skip_relocation, sonoma:         "a5eec40a06bb25ca5deb48fda9b5b261768ad93c9ed7b4ae1528909b1f9ad525"
    sha256 cellar: :any_skip_relocation, ventura:        "c2472b357eacc66d66c754f1386ca33cdde0c8acb8ac4caaf8c9cd46beb672cd"
    sha256 cellar: :any_skip_relocation, monterey:       "6f276d3c89ee2cd3a77ec835a7d5bc013f79384f3edb3c060148bbe4b965c050"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9b09fe7986748f5003d1772d7edd5604d24859a33f4a71daf56d6ae366b99f5"
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
