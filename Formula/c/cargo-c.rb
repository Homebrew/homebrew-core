class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.10.12.tar.gz"
  sha256 "ae118882067e1e7dcd8106933329cf018ddc6ea56cabfea7642a7699d6ce700f"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "93eabec8c07314b2ffa10da04e1c5a8680811b52746cc003d1f692c369f68363"
    sha256 cellar: :any,                 arm64_sonoma:  "f6a450122898ab833029022d1304918e8d5e8ed0776f662b1e2b56d467080d3f"
    sha256 cellar: :any,                 arm64_ventura: "81448628a286cc6b30d9374103706490600e50fb2500316d8e1aafb5eb5805a3"
    sha256 cellar: :any,                 sonoma:        "61ce2d2c5cb0a8072cc4258b09f4b8d3a8864d3c8c1a6c64c2e750b6d2c9164a"
    sha256 cellar: :any,                 ventura:       "29dded3c27c5c6e011f9fe530b63e6c1aa539ec62a948cccc467610d3c17ddeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7ad0460d3c55f96057e1560cfcb58a1596b9b23eedfa5ae250bffaf550b4768"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6e540ac5f80fc34832486811dc88991bd5d59e181f20c3d76220dfcba1333d3"
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
