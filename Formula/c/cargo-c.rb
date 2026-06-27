class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.10.23.tar.gz"
  sha256 "17679af6c00a70ce1d70668023e993045539afdc7ab0ca1a081aa8ef6993a595"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "20849665ff5f2ce89bbc748dc3447e36cd2c97ab108bd183a4d61ee4df105bcf"
    sha256 cellar: :any, arm64_sequoia: "15702b52bf1c6da2d499ee4e8d810e8162a42b28b4db1a739768855eb1f2f71d"
    sha256 cellar: :any, arm64_sonoma:  "ecfce6bb65a09f3c63522f04df8863487751a7be9f3ee775a6253195d31f4de4"
    sha256 cellar: :any, sonoma:        "aec24a40b2fa4b967140285f0150e3e2df034815d4de83956d9b3a671b11f517"
    sha256 cellar: :any, arm64_linux:   "9b1dd64c1e8f4821ab3ab454b5b11b75cedf84faab39ed3f3de3b8b720b17b2d"
    sha256 cellar: :any, x86_64_linux:  "40de20bcf47149499b57456bd012b2b04d50c12fec4bc1625043b7b097810237"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    system "cargo", "install", *std_cargo_args
  end

  test do
    require "utils/linkage"

    cargo_error = "could not find `Cargo.toml`"
    assert_match cargo_error, shell_output("#{bin}/cargo-cinstall cinstall 2>&1", 1)
    assert_match cargo_error, shell_output("#{bin}/cargo-cbuild cbuild 2>&1", 1)

    [
      formula_opt_lib("libgit2")/shared_library("libgit2"),
      formula_opt_lib("libssh2")/shared_library("libssh2"),
      formula_opt_lib("openssl@3")/shared_library("libssl"),
      formula_opt_lib("openssl@3")/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"cargo-cbuild", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
