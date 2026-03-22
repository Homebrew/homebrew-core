class Pkgx < Formula
  desc "Standalone binary that can run anything"
  homepage "https://pkgx.sh"
  url "https://github.com/pkgxdev/pkgx/archive/refs/tags/v2.9.tar.gz"
  sha256 "cfd226d7e1b77655198077d284501e31fe72440ad1cd8bb8711460f9171b7b3a"
  license "Apache-2.0"
  head "https://github.com/pkgxdev/pkgx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e48e831283da3339e328ef009f3b4e33b0a994dda616ead317980c2b6d76aa2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6eecf3dc0750e0ae1f2b629c78c8027d03b996473832926bfbb14c827b1a66b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "038fac4ea1b456e481a6eeeed9d1f4051e083057ab3f7d0232afe3b187367242"
    sha256 cellar: :any_skip_relocation, sonoma:        "64c199765ee22131a1d71336bfe7d776f44142946f887aed79eadb0bd98fae04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b6fe397c70c9905b5177740f725e21c9900c016ebc29ab0e0e5f95e18bdbf0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a06df4b08554f1582412244a68e59624cca20a8cc3ed51479bb86a53674a9e09"
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
