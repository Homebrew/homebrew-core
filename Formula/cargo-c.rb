class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.7.1.tar.gz"
  sha256 "4139690718894606e02a76e857a88f4b7482181915644aa4a385aad9f02f3573"
  license "MIT"

  bottle do
    cellar :any
    sha256 "372d86aeecfe1893b9c2b145e61b104006994a4e7789882d53da26fc49b72f2d" => :big_sur
    sha256 "4c011f849021fc11e1a8653a51801005d01e6d2e8a78469ddff142746c001110" => :arm64_big_sur
    sha256 "21a54e939d26c13ba57ef1fa17ddb53462d3d14c28c38a279043ab5bbcfc4aeb" => :catalina
    sha256 "1c88a7b973be92f6e414645a336b0bcc8f0e2d523bf3bbfede1b69929f031f2f" => :mojave
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
