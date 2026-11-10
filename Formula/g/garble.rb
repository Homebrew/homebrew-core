class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "56ca8f1c354eb1043c18099726c7ab7b685751d5f020434561b1676308ea9754"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e912468f827c6c6764fd7a1402505f9c2806b2afb0e2fd800a637e96211723e5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e912468f827c6c6764fd7a1402505f9c2806b2afb0e2fd800a637e96211723e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e912468f827c6c6764fd7a1402505f9c2806b2afb0e2fd800a637e96211723e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "44442bab719ad1903050a10813ac3e6f8d071c05c7f85f57fd6df01aa2acb08a"
    sha256 cellar: :any,                 x86_64_linux:      "33dce50a5b7a337caa864b65f5f72da87fffb554e345f3b4fd5439f57d27f4e9"
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
