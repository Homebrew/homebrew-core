class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "b429b24dafa851a25bbeca635db33eb4162b8e3109fb234a2c8e7780a837b958"
  license "BSD-3-Clause"
  revision 6
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b21a0ac1c6ad0924f95cbfbbf328594de7fd04af1c692934b0cb507b616a9e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b21a0ac1c6ad0924f95cbfbbf328594de7fd04af1c692934b0cb507b616a9e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b21a0ac1c6ad0924f95cbfbbf328594de7fd04af1c692934b0cb507b616a9e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "71fcf9e2a69d9ba7ba249d356f5367beb7ab6add049436cb6b14e891ba04e5e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "371a55ff9ec704ce35d23c440d76dd6eb1801ee3b8a541d52089c789354eae3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "224a27f6cb5daa3421fbbaa6d5788e0d0195558e190ccb6ee9f2064011104aac"
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
