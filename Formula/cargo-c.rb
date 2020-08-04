class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.6.10.tar.gz"
  sha256 "3e0f6c70291e48b09f936a5918656159b1d840d7a3b010316d0fc61e9b048bca"
  license "MIT"

  bottle do
    cellar :any
    sha256 "0a309cfabc5077f0b9d86d1f964afc57a8e541d11f14492a08fec3bc7983f01e" => :catalina
    sha256 "288f0722b00b073196f1f8ebe2a89d8ed8ef2684ebcc9329175e3266945ac2d7" => :mojave
    sha256 "2bdfb189d7aa1a95d09a283c5f3b42acf4dacd823365022cd6f591f8f391f0dd" => :high_sierra
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
