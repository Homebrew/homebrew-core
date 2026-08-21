class Pkgx < Formula
  desc "Standalone binary that can run anything"
  homepage "https://pkgx.sh"
  url "https://github.com/pkgxdev/pkgx/archive/refs/tags/v2.11.tar.gz"
  sha256 "28f205234b62602e8a6f468335a2468765f019118ed34b1dbff0531d28ad9c43"
  license "Apache-2.0"
  head "https://github.com/pkgxdev/pkgx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51fabd1be8621f394f309f691da9277911dd963063e9ab5e350c578187541ee0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3606e8f51c21278f08b3740967b72674a21476cc5a6a5d6375c6b2bbdb282a92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b0ab76b01c7de3e7d84133a66addc6e9bd00f158e03b0127e199ad7357f4f43"
    sha256 cellar: :any_skip_relocation, sonoma:        "d36ba2b666feb55fce9347a488d6c177bdafff941a817d642545a7310eedb8e9"
    sha256 cellar: :any,                 arm64_linux:   "bbafc4c7c3e5dcf89da961a176e69b34d7285c292277c3f1549aec25899399f5"
    sha256 cellar: :any,                 x86_64_linux:  "df710ccc5f92e673dc396882274a93ed2611cf5c9c7b0b5f2fbf8df9f70f02db"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "sqlite"

  on_linux do
    depends_on "openssl@4" => :build
  end

  def install
    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?

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
