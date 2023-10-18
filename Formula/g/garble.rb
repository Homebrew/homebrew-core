class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "11c038cb5fb6b21a2160305beec939c69b0712e39f52f0a0b6d977fa68d5b6db"
  license "BSD-3-Clause"
  revision 4
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3cfb8e2fa7af6609d97fe4fec85b5d977928d9b95cfe9cf588f7f558ac3654b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ab65073cdcbf6a49d4b6725c2c41e69b92f40caf26ca01e3f5014d35645ff2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f5f82a21c96e8dba74aba7889eb38cd1c5d2cbfca7071936d54cc5f4cf528c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a27d163a5e5e0e3a62f07bc621619af66bcbafec871d7fff9070add9b9c83d9"
    sha256 cellar: :any_skip_relocation, ventura:        "c001aaa7a1ec6dd0ed687ae2dfaecbd1a5ac94f79009fc302e7dd64721873d08"
    sha256 cellar: :any_skip_relocation, monterey:       "5b8b8e5c83de6015c768479b932f3d635ff18b24b08bfca0229ca770aaac2dbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9678e341005100d64418cbe0a990a0b06a79f357c80ae66e36ad112a99c71df5"
  end

  depends_on "go" => [:build, :test]
  depends_on "git"

  def install
    inreplace "internal/linker/linker.go", "\"git\"", "\"#{Formula["git"].opt_bin}/git\""
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"hello.go").write <<~EOS
      package main

      import "fmt"

      func main() {
          fmt.Println("Hello World")
      }
    EOS
    system bin/"garble", "-literals", "-tiny", "build", testpath/"hello.go"
    assert_equal "Hello World\n", shell_output("#{testpath}/hello")

    goos = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOARCH").chomp
    expected = <<~EOS
      Build settings:
            -buildmode exe
             -compiler gc
             -trimpath true
        DefaultGODEBUG panicnil=1
           CGO_ENABLED 1
                GOARCH #{goarch}
                  GOOS #{goos}
    EOS
    assert_match expected, shell_output("#{bin}/garble version")
  end
end
