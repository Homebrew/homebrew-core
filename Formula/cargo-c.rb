class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.6.2.tar.gz"
  sha256 "c0a3e612b41f441081098e3f3e1716fc709421f3d17654a9f0303f420fdbc1ee"
  revision 1

  bottle do
    cellar :any
    sha256 "9a3ef103003383aa8647d20df11de8fd10ac94a6b0c2efe518101868d70f28b1" => :catalina
    sha256 "b752165365f28505a61acf3b9496da1faef023ee709274c14529c0efa2d147db" => :mojave
    sha256 "a7094727446c2a705e9d4a878fca7080e030dd801ace7ed99e1bd195fcaffa8a" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@1.1"

  def install
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"

    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    cargo_error = "could not find `Cargo.toml`"
    assert_match cargo_error, shell_output("#{bin}/cargo-cinstall cinstall 2>&1", 1)
    assert_match cargo_error, shell_output("#{bin}/cargo-cbuild cbuild 2>&1", 1)
  end
end
