class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.10.14.tar.gz"
  sha256 "eb6d09e871516083448f77b8677dbefc1dcc14e88d73eea82bcee903343e19c1"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8bed59dab82a4573e7f2f120b669c27e178ce6317a9ea2866caace2b3662850c"
    sha256 cellar: :any,                 arm64_sonoma:  "d20b0a7357d803a0cf41b03485d7792dc7672510b39a3df2444976bdb892dad8"
    sha256 cellar: :any,                 arm64_ventura: "34bb0cde238ffd3446bcd69d4305655920510f88633183005c4f5ddcbe0bc303"
    sha256 cellar: :any,                 sonoma:        "af635e5a81adde8bdebed39c186b1bd381969e0eadbea782fbb351dcf3530642"
    sha256 cellar: :any,                 ventura:       "58b7b3512025f9f26fad0331d3b9f88e5d123bdd68709189ece41431629c5284"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "842c4f63eeed83d8135fd5c1b3718cc819dc1ae898bbcad5e267871e40d7eeda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd327a41f0a9eee3654526b1b835d8e50d67c0917e84601d39e5902a25f1af7c"
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
