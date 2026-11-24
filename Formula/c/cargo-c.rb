class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.10.28.tar.gz"
  sha256 "1069764333ff3ef36b8822be6a058d5241b4d12884ac003e7d66695a8a1238e9"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "24f84ceb9134fb49da2811c54c2bbc3e582fe87d424ac79b29fa230592c6e543"
    sha256 cellar: :any, arm64_golden_gate: "491d993ce0acda5c585b78106ca3629bfd0b931b7469eefc796bf6935b38c8db"
    sha256 cellar: :any, arm64_tahoe:       "afddb667cf33c86a8c91c9fc8136fd1e13ae1dd09e1cce41b0c665f940c8d4e8"
    sha256 cellar: :any, arm64_sequoia:     "d924c51f87e7003b36aa2cd9e24f10e914573812be4e92672a614cd7201d64a6"
    sha256 cellar: :any, arm64_linux:       "10457d2a28a85a3f7cbd3144fdd145780c173bbf1c569de05d42a68f2cfaba85"
    sha256 cellar: :any, x86_64_linux:      "3fb445101cafbe27c7a8a04cf48c76c82cecac709aa5ed78226eb8c34c73ef1d"
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
    # Tarball lacks `Cargo.lock` file
    system "cargo", "generate-lockfile"
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = dep("openssl").opt_prefix

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
      dep("openssl").opt_lib/shared_library("libssl"),
      dep("openssl").opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"cargo-cbuild", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
