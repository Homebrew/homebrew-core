class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://static.crates.io/crates/cargo-c/cargo-c-0.10.26+cargo-0.100.0.crate"
  version "0.10.26"
  sha256 "5ff6e05531e58286d3c02ec0adb7f254e5d532a8d4b667f30b9942d802e1db25"
  license "MIT"

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d4147427eef427595fe053c750508bc7f9e580cf946b2d374648319b25e20592"
    sha256 cellar: :any, arm64_tahoe:       "3dbc1cc9570dcb085be641c3de1dd7cd38dc0ae03f011eadc6ebe413a6f65451"
    sha256 cellar: :any, arm64_sequoia:     "5c0c3d446d1067668275333b63c24c348ce4732768368f808d12af907672d547"
    sha256 cellar: :any, arm64_linux:       "8bdb4d595ea1a80873b37805379b3b5d8d3a338bd4faa70f52aa93df4a81624a"
    sha256 cellar: :any, x86_64_linux:      "0ce0e3ed42df0a0d74eea5e66f726683d44cd65587039166c21e4b6cda43fb1a"
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
