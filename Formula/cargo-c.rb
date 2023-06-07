class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.9.20.tar.gz"
  sha256 "6a89125c4b59279e73f977ef8a7aa5d83240bdf5d1d7ef1a53b8d1f2201a5f41"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0ef918f4ac14aed41aad62420152533545a7c30df1aaa7decbf5f24a24cbfe0f"
    sha256 cellar: :any,                 arm64_monterey: "a88e7657da288b4e0accdde40c90412b32bed613cfd07e08bba528e3b2798bd8"
    sha256 cellar: :any,                 arm64_big_sur:  "c6019ed5669a30050e930238f1ee1a1b55abd982452bc4675ad5ab451a0a9598"
    sha256 cellar: :any,                 ventura:        "5071bf3109f1dd47da21aa963eb7b8f22e11e284c5fc48d91e4a58b3bd38da13"
    sha256 cellar: :any,                 monterey:       "66f340f5e65ee81878656583c171e896c17f150d76d66c9b465c1a990592c395"
    sha256 cellar: :any,                 big_sur:        "40eb74a8f25c69a5d1de47ee88cb82da19f6ae16ddff1c1d0c2bec7fddca2c48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54e4efeb971184e3b265a2c36b7e911a3f043d872f05fe6d09d03033f117621e"
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
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
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
