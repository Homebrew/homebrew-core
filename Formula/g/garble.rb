class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "56ca8f1c354eb1043c18099726c7ab7b685751d5f020434561b1676308ea9754"
  license "BSD-3-Clause"
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cc64811a6f633848f1d6e06f95f1ee47821d23251ee913d1635a3da8a36f9ec9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cc64811a6f633848f1d6e06f95f1ee47821d23251ee913d1635a3da8a36f9ec9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cc64811a6f633848f1d6e06f95f1ee47821d23251ee913d1635a3da8a36f9ec9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "56ad8af355db29da561a4063723961e31444c0415bed8ad10c8056e091d37f8e"
    sha256 cellar: :any,                 x86_64_linux:      "4647c4cc9342d87053932f601959eafc3e4a6e49d67cb4e970328c9d65ce2c40"
  end

  depends_on "go" => [:build, :test]

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"hello.go").write <<~GO
      package main

      import "fmt"

      func main() {
          fmt.Println("Hello World")
      }
    GO

    # `garble` breaks our git shim by clearing the environment.
    # Remove once git is no longer needed. See caveats:
    # https://github.com/burrowers/garble?tab=readme-ov-file#caveats
    ENV.remove "PATH", "#{HOMEBREW_SHIMS_PATH}/shared:"

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
