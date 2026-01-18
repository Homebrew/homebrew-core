class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.10.19.tar.gz"
  sha256 "4136fbb1c25b1afdf1aaf473d00e532b73bbe02c7c53cb44965aff41ed328d20"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a0fc12fa304e8f3d6e6da5f3b4102fece1ff805f74db598307c640166109d50d"
    sha256 cellar: :any,                 arm64_sequoia: "6c90e4f41d655a3276220fb84e85dbcc43a90b44e5cdc80abf2176856996292d"
    sha256 cellar: :any,                 arm64_sonoma:  "66fc6fe0919060b77b55e4c2093ea1706d9e4591aacfb729f70e6907e6d096ef"
    sha256 cellar: :any,                 sonoma:        "77d52429fb9bd2ba4aacb661bde0f1f4a6f0381aba6bec7ae39470e6fc3a4649"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08125d8735a2d7f3d5df6e84330f1d7dc7dd51354a0ea17fcad002b3dc7a86c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "902de003eaeecd02ab357a49fc675de82846b09f270e93f8778cab37f53706a6"
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
