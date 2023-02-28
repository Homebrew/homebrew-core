class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.9.16.tar.gz"
  sha256 "a84e31fa1718db05f0c7708aff0688858362113d35828e0bc478199b5761256f"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "60e294e3a3e7a4b34f3c7a2d7c3499381978274fe6d8b52c435984e9d43b5013"
    sha256 cellar: :any,                 arm64_monterey: "97a703d772eb976655113393c1c2aa1d8e8f34a25145bad75c1859c4bee859cb"
    sha256 cellar: :any,                 arm64_big_sur:  "7a2e70ae9fe9743f3f0f3a8a3311beff797a3b7e9536b83c5fd3e252602559d5"
    sha256 cellar: :any,                 ventura:        "9b2fd455a711ad35bda33e789df43c838a03ae660ea29797c59215511604edd2"
    sha256 cellar: :any,                 monterey:       "4a466f143727f9311fb97b4ddc67a5069df9e3b8536787ab80820330492b7836"
    sha256 cellar: :any,                 big_sur:        "2f764fbfbe6a3391246ec9ab49f6b1ea17a2529229d8a2ab218a580189780689"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f19b37500292957402dbd65df801845c267097607d2b74c96867fe4791d09cf7"
  end

  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
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
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@1.1"].opt_lib/shared_library("libssl"),
      Formula["openssl@1.1"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-cbuild", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
