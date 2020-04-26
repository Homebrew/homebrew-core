class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.6.4.tar.gz"
  sha256 "6504e0b36e64fe8eead1e736e4f60ab3197da99f1e2c7838cb0f63f38158dafa"

  bottle do
    cellar :any
    sha256 "96cb4175b93ee37f67018d87c6557541fba709f089447aee6a71c829cf32c6b4" => :catalina
    sha256 "cf600fb61ffa693a75169a73e86580181fc0662f6f665110dca6cbba412c1be3" => :mojave
    sha256 "17932fb0f81fcfd6a0b9efb1d78a0dccea1cb37098073dcbcdf2b65b94330ab4" => :high_sierra
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
