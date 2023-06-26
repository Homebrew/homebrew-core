class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "11c038cb5fb6b21a2160305beec939c69b0712e39f52f0a0b6d977fa68d5b6db"
  license "BSD-3-Clause"
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8990edabaf932bdd92235fde4d67e8d8d65dadaec022df057838be6a187f8ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8990edabaf932bdd92235fde4d67e8d8d65dadaec022df057838be6a187f8ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8990edabaf932bdd92235fde4d67e8d8d65dadaec022df057838be6a187f8ad"
    sha256 cellar: :any_skip_relocation, ventura:        "c410a13d2c1515a558d650569855279fdd19b7b705cb616334d69363ceb6659d"
    sha256 cellar: :any_skip_relocation, monterey:       "c410a13d2c1515a558d650569855279fdd19b7b705cb616334d69363ceb6659d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c410a13d2c1515a558d650569855279fdd19b7b705cb616334d69363ceb6659d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18b98146dd41ae532c5f29a106793ce0118022310cd5eaf1041ae0cc735b4366"
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
