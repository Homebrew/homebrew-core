class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "78b418d98b1d24549bf660a50054263206c3eeccf6820438f10e8568b81a1bfc"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "551004bd1f9c64dcb4a5082a16c41b5d10ec6ba3e4628ed3dac9be0140e2a84a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "551004bd1f9c64dcb4a5082a16c41b5d10ec6ba3e4628ed3dac9be0140e2a84a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "551004bd1f9c64dcb4a5082a16c41b5d10ec6ba3e4628ed3dac9be0140e2a84a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d9a75353cce2343f072849fe03b0bb184800226674040cbe774146b7219366e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8b7724e25281d3dc665b6245e406045eb44865043d8caf759f945874eaf9728"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c19f963d6bd9306f60aa976ca337541635ad88794b240892fb05272c9d4e924"
  end

  depends_on "go" => [:build, :test]

  def install
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
