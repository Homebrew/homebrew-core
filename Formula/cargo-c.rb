class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.6.9.tar.gz"
  sha256 "d88bad2ada3432b15d2a871a5071f2bd7554beec5ecc4807c91599533de76cb4"
  license "MIT"

  bottle do
    cellar :any
    sha256 "c4b83b9a8932ab1c15706585dda3ec88b75c966c967a25661f479150e4c29d20" => :catalina
    sha256 "97f34a38dae6ffe05ff7b03fda5c6fd8db83a23acd6d2d19abd4b50306d2a022" => :mojave
    sha256 "2633e4edabee4b62a5959a068022356e914db735201437b9c813cc19d58b6bdb" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@1.1"

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
