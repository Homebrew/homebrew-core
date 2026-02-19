class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "b429b24dafa851a25bbeca635db33eb4162b8e3109fb234a2c8e7780a837b958"
  license "BSD-3-Clause"
  revision 7
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2fcd004e1636ef65692d3b863a99740624ebc3d4b2e33270410754a92d9350c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2fcd004e1636ef65692d3b863a99740624ebc3d4b2e33270410754a92d9350c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2fcd004e1636ef65692d3b863a99740624ebc3d4b2e33270410754a92d9350c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8bc50c5301d346303be7648bb978338393198c2c5898c979f7ceb0cd2663683"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd2a115ce808d6b7e052dfe8f885f319695b4b9b99ae30c6ffdca441bbcb20b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "902170d36e85bf17896979c2248fed20f2ba435bd2716051be2c5ddd44ed57f4"
  end

  # unpin go when the release is supporting Go 1.26, fixing https://github.com/burrowers/garble/issues/990
  depends_on "go@1.25" => [:build, :test]

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

    ENV.prepend_path "PATH", Formula["go@1.25"].opt_libexec/"bin" # for keg_only go 1.25 binary

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
