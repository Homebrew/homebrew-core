class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "78b418d98b1d24549bf660a50054263206c3eeccf6820438f10e8568b81a1bfc"
  license "BSD-3-Clause"
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44a60fac5f63b9d470e234e43571fb76492d983b12cf59b5032db9a2be8e1e91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44a60fac5f63b9d470e234e43571fb76492d983b12cf59b5032db9a2be8e1e91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44a60fac5f63b9d470e234e43571fb76492d983b12cf59b5032db9a2be8e1e91"
    sha256 cellar: :any_skip_relocation, sonoma:        "63d222c79bc07d78bc25cb23ee94aea30d5172dc79d1c624df93eb3ba007613e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "103e76499b31af9b7369b0da1f5943227850cc81197b6155ad783ae16b5517c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf3aed367c9dcc302ad5deff4268171b803fb5ef103b96de9d3937b7aae2d36b"
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
