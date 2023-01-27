class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.9.16.tar.gz"
  sha256 "a84e31fa1718db05f0c7708aff0688858362113d35828e0bc478199b5761256f"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8bd2dca0982170de1d022ea041f780b6d781b4ef641076910d2c3cfc37554d11"
    sha256 cellar: :any,                 arm64_monterey: "eb2cb2830b2eea3e4af89125928eb3bbf0fc8f2180b4b2ceccd6ed1175738fdc"
    sha256 cellar: :any,                 arm64_big_sur:  "415c81f580ebe951ad694797395921f52f4718b3b0cf76b3c2f1d7840f50ccc8"
    sha256 cellar: :any,                 ventura:        "4f57e3ad4774f8af86990f6a98ed28b136aa6e9c2c5c4472d83f9a7ab2df01ca"
    sha256 cellar: :any,                 monterey:       "4e62f45fbd97805624ab001cb6a67d5b200bd1c7059567e483a453b159c01f85"
    sha256 cellar: :any,                 big_sur:        "cd624e79d0282347b1918cd6ca75f7a80e8304f6d63feb46aaea5242a55e86bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5179d65bf4d109c68987d15b16cd074f7eac8c41ca0ea65f699bb06f155eebc2"
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
