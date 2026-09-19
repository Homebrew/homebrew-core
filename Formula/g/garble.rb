class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "56ca8f1c354eb1043c18099726c7ab7b685751d5f020434561b1676308ea9754"
  license "BSD-3-Clause"
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "290227241a741481fed7e63c4ccac9abe19863fb6309330c8bd31010d38f17ba"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "290227241a741481fed7e63c4ccac9abe19863fb6309330c8bd31010d38f17ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "290227241a741481fed7e63c4ccac9abe19863fb6309330c8bd31010d38f17ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "290227241a741481fed7e63c4ccac9abe19863fb6309330c8bd31010d38f17ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cfcb885c94cfb38785c1e5ea932021f454ab97dfc10f959af6586b5126fdf1bd"
    sha256 cellar: :any,                 x86_64_linux:      "3856487659a02f1d90d0f6ad467d5bde8b2f253ff21454faca452602ed421179"
  end

  # TODO: unpin go@1.26 when garble supports go 1.27
  depends_on "go@1.26" => [:build, :test]

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
