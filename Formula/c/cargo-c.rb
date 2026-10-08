class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://static.crates.io/crates/cargo-c/cargo-c-0.10.25+cargo-0.99.0.crate"
  version "0.10.25"
  sha256 "6b2ddde58a8a773ccce4b6384acacd3ce01373f52717dd2424633ed46755c627"
  license "MIT"
  revision 1

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0d71262d524db3e19ad34dcd815c368816a82fbee67a5342aea9c4b3afd54a91"
    sha256 cellar: :any, arm64_tahoe:       "eb13fd4d7d4e986d0865a581f008dd963e9f38417fcb782470f35eaec7b622b3"
    sha256 cellar: :any, arm64_sequoia:     "097299cf61942672a6845b78003ccb81f3821871f01fd06b81fb069b03cfe47e"
    sha256 cellar: :any, arm64_linux:       "31585985200e33b1fc1f26cf99a7ad892f7da398a82e8a2129f1577a97ec1fbe"
    sha256 cellar: :any, x86_64_linux:      "9f6dc50e0f0e712f6b87b62da625ae6a5a07f3712faaa4eec5c9fe38f0004bff"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@4"

  # curl-config on ventura builds do not report http2 feature,
  # this is a workaround to allow to build against system curl
  # see discussions in https://github.com/Homebrew/homebrew-core/pull/197727
  uses_from_macos "curl", since: :sonoma

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

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
      formula_opt_lib("openssl@4")/shared_library("libssl"),
      formula_opt_lib("openssl@4")/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"cargo-cbuild", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
