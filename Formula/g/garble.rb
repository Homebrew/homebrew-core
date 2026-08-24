class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "feab001d7e9ff4ce66011ebd70791de93eb1554d34d3ea44c33d102a25c1be0a"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c3a9a09eabb20310e05aab70435ba025638370c154a94e4ce714bbdb91855e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c3a9a09eabb20310e05aab70435ba025638370c154a94e4ce714bbdb91855e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c3a9a09eabb20310e05aab70435ba025638370c154a94e4ce714bbdb91855e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d660d3441b11bb70ce684dc8c906e68a80514a0767dd799d8973a067b81f512"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa7bfd8ac097cf555210f737f8f83a721340ae510fc5668047a13dec46b15868"
    sha256 cellar: :any,                 x86_64_linux:  "9390904c7afab4c67480f73c44d18e6911801d1ff7ed37df15b9f4d79f5890a0"
  end

  # TODO: unpin go@1.26 when garble supports go 1.27
  depends_on "go@1.26" => [:build, :test]

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

    # TODO: remove when unpinning go 1.26
    ENV.prepend_path "PATH", formula_opt_libexec("go@1.26")/"bin" # for keg_only go 1.26 binary

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
