class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.8.2.tar.gz"
  sha256 "86e5015e2eb834256307397adc23b3faa0c7522725a75b3fd735cfdd06d02725"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "5fd9dc5cfc5f9d496aedef34c289b5dcd245c07367297006a64e5faaea07e410"
    sha256 cellar: :any, big_sur:       "72f7222a9aa889df49596b7b1d293964947da07346ac9966373c2f2b0236c5c8"
    sha256 cellar: :any, catalina:      "9b72df8ac9dd708af9c68d2da285aa3c6a3e6b9bba807305150c34c46b3d3735"
    sha256 cellar: :any, mojave:        "27a668a1ad6e3337f25a4c7583d925d1b74c8cd290dc87a37cf3910956110df5"
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
