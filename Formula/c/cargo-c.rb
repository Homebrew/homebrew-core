class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.10.18.tar.gz"
  sha256 "0f2b699be7ad5cac05624701065ae521c7f6b8159bdbcb8103445fc2440d1a7e"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5b1949b951da003b42de263c8170c825f9aefd44772af0ae956c57d80d3159f9"
    sha256 cellar: :any,                 arm64_sequoia: "6794c0c0a72eefaeed40ce4c03e53d68836a95e6a91c527ff7c4457b3d73bd20"
    sha256 cellar: :any,                 arm64_sonoma:  "a88a4bb9e31fa64875e68d5baace6548ad6b553da41d8790e684b12fb1ada6a4"
    sha256 cellar: :any,                 sonoma:        "ee834e8d29c526dddbf7a0c12f101f892de9018e1d87461a1c51e89d658f0e1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c73b5c8b73687c41823fc7d91f3a56c828847262eba570661529f2db9e88fd8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e5780a504a0a80cf05c761ba78dd7233cbeb767e46d346620b04bc404a022ec"
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
