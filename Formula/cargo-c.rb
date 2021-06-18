class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.8.2.tar.gz"
  sha256 "86e5015e2eb834256307397adc23b3faa0c7522725a75b3fd735cfdd06d02725"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "5433972a3bc33d1517a92d13aab5c4286cb222f246f0768415810f86ebd5aa5e"
    sha256 cellar: :any, big_sur:       "0f666835f9161526134546466e73bd190c7b765941d15d7208e4fa86946b541c"
    sha256 cellar: :any, catalina:      "52e30a65673411d7c609b10052203d9aee7fe30b0b55d13f1a8a6db65f2776cd"
    sha256 cellar: :any, mojave:        "1dbb9b622b54b7d6a28814c0508c122aab105d8cea2646c3e959567fe5a9a70e"
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
