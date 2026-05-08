class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.10.22.tar.gz"
  sha256 "a7b00539437932f2a17a72b97d9c2142367a2d70ee20f9f1692a8b13c7255332"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "43cd29ac3cee0d98bd2289d1c1e9594270aa3026b910faa38bf3817f9256f833"
    sha256 cellar: :any,                 arm64_sequoia: "e6adb4dc49172dc8d06a336f4befe8113dfaa6bb1645b7cac86a90837f07104b"
    sha256 cellar: :any,                 arm64_sonoma:  "c0ec8f43d146cd43444593d566608fddd5eb4124c4678cb2ee923f8fac143f05"
    sha256 cellar: :any,                 sonoma:        "c1c919200669a7814098c7c9d9ff7fa7a3a9d82c49fb1123e0a53bdaf2d5c8ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c680d77013aaaf0236f971125f32a9fe2d3acbfd4c9ebc46d5ab1bca47c86d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06884e195b37521169fff8db4154f057454e57b4458fa8c12cbac238f8be4890"
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
