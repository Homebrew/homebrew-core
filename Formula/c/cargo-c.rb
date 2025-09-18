class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.10.15.tar.gz"
  sha256 "59fe45092141f59b4d34948423a8e535ea8a2f0802a7436fb31e6c6663afa46a"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "642de913b254c1ae01ca4054b09fc85e32378c4be8c5e9ee96c729087b01cccd"
    sha256 cellar: :any,                 arm64_sequoia: "dccb5ede06642542cbcf4ff996e400860874c2e8407bb92dfb6b4bfed9c88b28"
    sha256 cellar: :any,                 arm64_sonoma:  "0c0e57d732a3c02a600adf51e928115f2aed3b0592c4f7ca00bf6342d554cdfa"
    sha256 cellar: :any,                 arm64_ventura: "09c151e8fd0f25348de43ef5fe9afcf0b39ed552ad91c724ac04fb146ae80dcf"
    sha256 cellar: :any,                 sonoma:        "a54c98c73299d351070ce5d6768c8c10952898c26516621eb22b8356428c1ee8"
    sha256 cellar: :any,                 ventura:       "3fcc1a6a71a07f18b7da4bc56db2101abc2c2ad337629e122391cb2ba5919356"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf2a96760dae3d987dfe2d9c12fbe77d4f8260c115850ca6d1f83ed9845a047c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "305983190b33ac036789b5054e07597e782071e7627645af11a4f598dcd1e573"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  # curl-config on ventura builds do not report http2 feature,
  # this is a workaround to allow to build against system curl
  # see discussions in https://github.com/Homebrew/homebrew-core/pull/197727
  uses_from_macos "curl", since: :sonoma
  uses_from_macos "zlib"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    require "utils/linkage"

    cargo_error = "could not find `Cargo.toml`"
    assert_match cargo_error, shell_output("#{bin}/cargo-cinstall cinstall 2>&1", 1)
    assert_match cargo_error, shell_output("#{bin}/cargo-cbuild cbuild 2>&1", 1)

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"cargo-cbuild", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
