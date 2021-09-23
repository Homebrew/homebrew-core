class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.9.3.tar.gz"
  sha256 "0e0e7d1f6490e47195f8d02e6b6eda058ec815756fab1ec8c811e1f644cc68f5"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "524f0b3e2e1911dffac72dbe2e19b2aa721faafb59c018ca676d5206ecc64084"
    sha256 cellar: :any,                 big_sur:       "5bdab9d2c486063f1c50be04b004689bda2ff5590f49515fa3bc46ce2e2b1aac"
    sha256 cellar: :any,                 catalina:      "b5da05f48efe3c2ef8a872bd4992c72d0dadac51624befab2492679dbd9064da"
    sha256 cellar: :any,                 mojave:        "6a698d6a82d67b90b9d9f86dd9caddd5904d1b1debf43d98f90f164eac04188d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a10bd6ab0782817de20a206e0a03514dd480c1271159d4a84fafafd647bff28"
  end

  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    cargo_error = "could not find `Cargo.toml`"
    assert_match cargo_error, shell_output("#{bin}/cargo-cinstall cinstall 2>&1", 1)
    assert_match cargo_error, shell_output("#{bin}/cargo-cbuild cbuild 2>&1", 1)
  end
end
