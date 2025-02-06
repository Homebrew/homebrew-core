class Pkgx < Formula
  desc "Standalone binary that can run anything"
  homepage "https://pkgx.sh"
  url "https://github.com/pkgxdev/pkgx/archive/refs/tags/v2.2.tar.gz"
  sha256 "3ff6f6a40ed07df9a2904941bb3ed2303d409ef3ce501b6667b5e5a4ed7c9712"
  license "Apache-2.0"
  head "https://github.com/pkgxdev/pkgx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e22a41ec6217cbfcf72c897ac4f7734f2cb994d7f6cb370665913665246e72e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2da9e65435edae4ad738e3ea9a91ef20d21e29192794b2bb9fcb6f1b0c9bbe04"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "64ebd49230eb47597283597fb6ba73e53837cdc099fd0843d3d761ec624271a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bca688c06bfca52db82aeee08a086af2b34c73f1a1b9370ff25d46f00338aac"
    sha256 cellar: :any_skip_relocation, ventura:       "a627790c732a53cbbc476bc9f2d3920e7e3ec30ccf03b9888aeaa8953144a261"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f86bb043d4bd636bbe42e1eaee46618cf4c68692adabc377e3069d0d73f63c1"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    (testpath/"main.go").write <<~GO
      package main

      func main() {
        println("Hello world")
      }
    GO
    assert_match "1.23", shell_output("#{bin}/pkgx go@1.23 version")
    assert_match "Hello world", shell_output("#{bin}/pkgx go@1.23 run main.go 2>&1")
  end
end
