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
    sha256 cellar: :any,                 arm64_sequoia: "8e962d96f9a4d59ff326bcd18d9ae76ca6a01b68864134048f375067681bd5cc"
    sha256 cellar: :any,                 arm64_sonoma:  "bd8b60660ca8d0c236ed303a2baf08dcfb6cbaa28dccc0ebc860fa0e7fa1374a"
    sha256 cellar: :any,                 arm64_ventura: "f74c2d8c404887078aae7f5f39bcd8aeb83a0e9835a8a67dd784e49d4befb13f"
    sha256 cellar: :any,                 sonoma:        "aca6f55647d5e338431ace98addcda3709bda3f249ff8cf906d8f2c9d73663b4"
    sha256 cellar: :any,                 ventura:       "52c389dd8cd35ae4bf06fb3dd991b3a217c042f98139bffd4b5e3a453e305cf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba9adb66a9a7078a7d61c4c0c2a42e4d480f0adc96ffdde86a8984b538e3a115"
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
