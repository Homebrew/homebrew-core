class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.10.24.tar.gz"
  sha256 "91c6e0be34aa0ad26b7ef21ce21a390c95635e4e6e00b7a6ff07323f9af8550b"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "66fa10af095494e68daa7d16baf8191e165135baf9dc82665b5cb0d981a91933"
    sha256 cellar: :any, arm64_sequoia: "a7b9cdd530482eff1273e5cb2cd1c29e741e406adb259a52378900cdb7b03ef1"
    sha256 cellar: :any, arm64_sonoma:  "97091b2ac1cc0557dde90136dc5c6918acc4b69d1b912a8389eb82847f44c6d9"
    sha256 cellar: :any, sonoma:        "8833f495f8db789001c1f47a059166e2f63d3f6c2e4e56a480671f408f3ebe32"
    sha256 cellar: :any, arm64_linux:   "457e66f7afa9f588b6d9e174facd2d73bc4ba0abee5ab92bee9bcbc59c8edd57"
    sha256 cellar: :any, x86_64_linux:  "5086ad42e1dcdcccfdff9cb17d2d6f58a9d2c851b12b51ee3e501581add4629a"
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
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

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
      formula_opt_lib("openssl@3")/shared_library("libssl"),
      formula_opt_lib("openssl@3")/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"cargo-cbuild", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
