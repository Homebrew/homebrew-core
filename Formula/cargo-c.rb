class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.6.13.tar.gz"
  sha256 "aa6b23c7ae19ec93e6edeb59be46056faccb915a02d1784a0c29ac7a3c6a8aea"
  license "MIT"

  bottle do
    cellar :any
    sha256 "af41919e5b362afb73c5cc3506ef08591cb1edd6a35832876d523208ddc9c51d" => :catalina
    sha256 "6ee6f29f098bdf4baa7f168b8e599b28458bc0de7892770067d5c82e1bdfc84b" => :mojave
    sha256 "efbca9b10f3978505b658bba9f23d2ce4f49479efa44d0e0fc3febf450e2987b" => :high_sierra
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
