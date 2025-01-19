class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.10.9.tar.gz"
  sha256 "4542e39aa67bf8712c60f21701cc8e8b5153d0344afe1b618f121f696b578a7f"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2f56ede8e629a5a5270d86d76bf7de1b3cc257cc5ae8cc437005cdbe64d30fd8"
    sha256 cellar: :any,                 arm64_sonoma:  "e94e14922d71d70bc01367502c1d0fdc96d55a93f5c49b49d4767970a2197a9f"
    sha256 cellar: :any,                 arm64_ventura: "44c4d7d150145e1ddf60b71deadb52c055a0ff7b56a35a136d049a0f7e4d9b1b"
    sha256 cellar: :any,                 sonoma:        "b396556328b67baefe153fd6974de40f3a2cbb35912fd5d75b335c0524fffbb9"
    sha256 cellar: :any,                 ventura:       "4fc6851877e5221343b72f37d9453cacccdefc1b40430676ea588afe1e9a186f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7d68a013e8af6f53b37482655dc99d9a0f32b73c5aeb417796a9e7c8d88ab0b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.8" # needs https://github.com/rust-lang/git2-rs/issues/1109 to support libgit2 1.9
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

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    cargo_error = "could not find `Cargo.toml`"
    assert_match cargo_error, shell_output("#{bin}/cargo-cinstall cinstall 2>&1", 1)
    assert_match cargo_error, shell_output("#{bin}/cargo-cbuild cbuild 2>&1", 1)

    [
      Formula["libgit2@1.8"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-cbuild", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
