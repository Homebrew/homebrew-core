class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "b429b24dafa851a25bbeca635db33eb4162b8e3109fb234a2c8e7780a837b958"
  license "BSD-3-Clause"
  revision 8
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fac51277b744e6c16b8cc4667c9e5d0e07f7329a46bb292bc79f967b8013b392"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fac51277b744e6c16b8cc4667c9e5d0e07f7329a46bb292bc79f967b8013b392"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fac51277b744e6c16b8cc4667c9e5d0e07f7329a46bb292bc79f967b8013b392"
    sha256 cellar: :any_skip_relocation, sonoma:        "162c0db6b8d12680cfc17a4a0b5834d8e6d55c7bc91d0d97021699c9a597e15e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce682fbe28be8c951bc1766cbed3564baff91fc79d0c2474efb92e8058511213"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37842bb21aa6e908df86b1c8e8f2e8acb574eff16da04d88ad8e8321c39b634e"
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
