class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.6.7.tar.gz"
  sha256 "872f5e1eb34e807e57096f5ea20b57c95cc40ab95fe938faa1ca915c68e73cc9"

  bottle do
    cellar :any
    sha256 "9fd28e5611437a0f5d436c11befb65f501a8b51bac65e50e52405b5c0dafa65f" => :catalina
    sha256 "c36758d5dc3a14d0839b9f5c97f9242804091a85ffd06fe79e9618e227edc345" => :mojave
    sha256 "5a6cf9b1d532128211a0095d9c9641e6982540dd7493ed65a85769e3975cfe64" => :high_sierra
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
