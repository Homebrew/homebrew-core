class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.10.16.tar.gz"
  sha256 "c0ebb3175393da5b55c3cd83ba1ae9d42d32e2aece6ceff1424239ffb68eb3e3"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ca4a3442330dd71c51d58f341efb6e61b45ee79a0c769d6b3243e028094dced4"
    sha256 cellar: :any,                 arm64_sequoia: "79f26b4f13f90bfb58657fca6f9724163864e90485f782e133de00012e2d9058"
    sha256 cellar: :any,                 arm64_sonoma:  "b492462e9a4a843498b48c7b950657647eed54c67d9191510bbe7035c11de54b"
    sha256 cellar: :any,                 sonoma:        "b4751b2f05fb6c0ebd44b499bd6bed52135d44a1f3a4ce820caf81f0c3b141e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28cdc7b91c6342464117286f5d1d97d920996d5e9c4e3042c5ba23b6f9233b1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d0018a3baa73a767c2c3f8607c0613d4ce07e705a9a7aa1c5225357f315eb1f"
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
