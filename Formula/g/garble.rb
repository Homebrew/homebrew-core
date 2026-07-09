class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "78b418d98b1d24549bf660a50054263206c3eeccf6820438f10e8568b81a1bfc"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d27ffc32ff6127e7a9ebcf94f85912d53f69d2cbaab66b23e4e76f675ea6bc04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d27ffc32ff6127e7a9ebcf94f85912d53f69d2cbaab66b23e4e76f675ea6bc04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d27ffc32ff6127e7a9ebcf94f85912d53f69d2cbaab66b23e4e76f675ea6bc04"
    sha256 cellar: :any_skip_relocation, sonoma:        "c201388fc8a878406da584f7f327134941276d40c72c6776fb6351ad14f63b0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9eff1a085596f5006253daa0bc9ec8bf9842e4b9801cc7755e8f24762b6984b1"
    sha256 cellar: :any,                 x86_64_linux:  "17d08366d09feba42e0434a8e9099ae500134c7e64019044c26ba9639b46b189"
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
