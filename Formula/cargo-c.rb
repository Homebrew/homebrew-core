class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.9.2.tar.gz"
  sha256 "9f93bfa47ab39ec84e5c9a6e86962349e0eeb8a73716ab3d1fd3edba1a0d885b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "9c6f7d6c6365c5c1e20b24cf30824a5ad526e55751ff4fd6e0a9aa9f377263ad"
    sha256 cellar: :any,                 big_sur:       "2224c7e4dc57d6736e60463fe7bfca8383743d8516d8d0f1b17bee5245134caa"
    sha256 cellar: :any,                 catalina:      "2a220a7a66bce444f34220fffcda84adf5ee6b6c727a536470ca49275c28384d"
    sha256 cellar: :any,                 mojave:        "24ca6d9177d5da676a5dac9bfa7a03ef2548eb82408c1239a9efeeaa8870c7b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "285fa73190d4dfc5d4652a4fd268fe8220d7399fd9828deb68b89471ccde7006"
  end

  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@1.1"

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
