class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.10.13.tar.gz"
  sha256 "57dffba592179c7ca2b0322d28265b6962750eebb3a23b28ad677371cc10c36e"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6648cce921132bfaa4effd2b8de568a28a7d8fcf73ffad93a64fbe3e7c946cd0"
    sha256 cellar: :any,                 arm64_sonoma:  "48b3d3986aa2927acae96c7ef2e04d3e7b0a38dd36030bcff6b6f722112dc012"
    sha256 cellar: :any,                 arm64_ventura: "bef2bf10472228ff2c1f0b4b71ef1556263116a061d879afe19306d94e18e3b3"
    sha256 cellar: :any,                 sonoma:        "f76b2138873df74174275f7dbdf0397c32a0f9d19d8dce6bff192cde1e1867c1"
    sha256 cellar: :any,                 ventura:       "5a0bdd4ca546d7e69b5f9ddf99e5a85f75d2b97c1e4d57c48f5e062c6ab795e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f06052e1491552d461eed34e34fe83e976b11eca475844067e5d10ed70384ef3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d810fec9f6c5105701fcac741c24e40e15f439113601b72fbdfa277064ada09f"
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
