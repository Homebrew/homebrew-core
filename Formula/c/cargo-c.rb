class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.10.20.tar.gz"
  sha256 "9bdf7c10b44466a7c01dc4ed152da5031793cca9e0c8009d73223a32522cf2c3"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "8681512c46461c387c5509d6634e20c685352b700ee1d3a3f7fd7f510ea2af69"
    sha256 cellar: :any,                 arm64_sequoia: "62138b153f97787013a63243e8fa78c2acc46567644ccfe0fd10b0e49b284a58"
    sha256 cellar: :any,                 arm64_sonoma:  "0b0679425b368b3017cd2ecb5792d19038d53db027a21e23481516b859f3d655"
    sha256 cellar: :any,                 sonoma:        "d255268040c0d723ac2a1cbcc7185da717e445479f85b0abf5977f2f96ae3899"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "935cca7212c22017a699e5fb8fdecebd03c5990a19c94df869c5a91bb77bf242"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7228f50abd22ea3892e11bb518b07cca2e5fb39124541c4b69333404447798d0"
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
