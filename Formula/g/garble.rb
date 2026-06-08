class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "78b418d98b1d24549bf660a50054263206c3eeccf6820438f10e8568b81a1bfc"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "709de7971d3af60e34f4aade805bbdd277078fe7f52fe1631e5ccd9b2f6d7758"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "709de7971d3af60e34f4aade805bbdd277078fe7f52fe1631e5ccd9b2f6d7758"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "709de7971d3af60e34f4aade805bbdd277078fe7f52fe1631e5ccd9b2f6d7758"
    sha256 cellar: :any_skip_relocation, sonoma:        "768771a117b1cbcbea4a4f760cc51b92fb7cfa6f7433d221c303f372fead2f76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5dd4ce92fc1c614bf54ce62fc4d2472eccb3e88e189f83e9db9c06e7acb6b96e"
    sha256 cellar: :any,                 x86_64_linux:  "2f6692bdc340a117281a51f417c8f3f9f56babfc13623b85680fe336d6ca5552"
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
