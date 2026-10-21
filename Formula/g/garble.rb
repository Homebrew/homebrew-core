class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "56ca8f1c354eb1043c18099726c7ab7b685751d5f020434561b1676308ea9754"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c2eb8a550eb5b567f05f46fe15c7b1625c663494e220be0ea952edc252482c4f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c2eb8a550eb5b567f05f46fe15c7b1625c663494e220be0ea952edc252482c4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c2eb8a550eb5b567f05f46fe15c7b1625c663494e220be0ea952edc252482c4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e2b83433b3f229faa0a9cf3bbe64c7fb313093e9eb6d7f323a1f2dc305df1a75"
    sha256 cellar: :any,                 x86_64_linux:      "23c93d730ebede1696fe4f245b4a660523bd5132df35b6317ae55d1650978240"
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
