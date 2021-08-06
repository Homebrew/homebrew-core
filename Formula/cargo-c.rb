class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.9.2.tar.gz"
  sha256 "9f93bfa47ab39ec84e5c9a6e86962349e0eeb8a73716ab3d1fd3edba1a0d885b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "97c23df26f4434e8ca3dfe644f585d03223bcb4f190a2cba0bc5e840585212e1"
    sha256 cellar: :any,                 big_sur:       "538b726ef6a18403c8627a68d9ff225d7d0bf71591a3709ed538e21327c9bfce"
    sha256 cellar: :any,                 catalina:      "7fce95456199ccc3064e7ad9540288d7b84f8ccbdc7bf541a8455b50ba706393"
    sha256 cellar: :any,                 mojave:        "c9015ac00b4910478ff20ac2f5ed7790dc24afa14c64b72e32351c4f9c617fc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0abc904deecc38b19fb7a4fc9fccd005c951ff43d666af39d9d30c08f8238950"
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
