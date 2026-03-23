class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.10.21.tar.gz"
  sha256 "819b62a61e5271924dffd122b7c713e446e5d65f3e630bbe9b90d4d46513d8fa"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2cbd2f1bc81889d7af79dddbaabd599e59e7b2427ca00d845ebbf67a0952dde0"
    sha256 cellar: :any,                 arm64_sequoia: "1776cbc0aac1f01f96591ee1ddd4815c5859d23c661fb645b410d6b24d8babf3"
    sha256 cellar: :any,                 arm64_sonoma:  "5624a2aeeab4ba3e10a24dc75750ba6b7c92f976e20af7e64f2575dda8cbda76"
    sha256 cellar: :any,                 sonoma:        "65a758cbb0a0aa5ef10c0fadde9e705dcbad0bb4a11e2ea237a3141da161a71b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89c6284905efda53e5f45d1ec89d6f95b671594bac5416c0e46e1722d7818b3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d16ec518c8cda3cfcb0d1e2e4289351855758df38c1e0235d57f445a07f0329"
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
