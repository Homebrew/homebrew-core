class Prr < Formula
  desc "Mailing list style code reviews for github"
  homepage "https://github.com/danobi/prr"
  url "https://github.com/danobi/prr/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "3c32911854a33a1a7870382db0e759923315ec943b5d43dec42d751820473094"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/danobi/prr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "4a822cf091a1f6789490698744ac828c6d4f36a6421830e24c114f7b0c485916"
    sha256 cellar: :any,                 arm64_sonoma:   "28f80c091dcaf14c6fe7733f95dadcd2d0bd2fa7b0d78f1ba848cfd6d64fda7b"
    sha256 cellar: :any,                 arm64_ventura:  "a8944bd7c8638a6359224c2b3c0b0013a4886dbf9b8742604f6e7ea7d35255b9"
    sha256 cellar: :any,                 arm64_monterey: "ffae88ab388c852d1b2b901a936d97907ea92716a602c335dc4a3972bba56751"
    sha256 cellar: :any,                 sonoma:         "5e5aa701fddf38bf75dc86ab1cac71b9243397cc80b9d87cc30262367b690468"
    sha256 cellar: :any,                 ventura:        "a74c399d838ade14f19e655f06a98e26f3a7d7ff9ee9944be51139ea194063fa"
    sha256 cellar: :any,                 monterey:       "41edc115e3e5173dca78d6b87332a320c4b3362873a63727a523c858b44a6806"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b261dc29a087e6b2f8cb517e1f3fcc0f465fddf33cfb7ae5c958d23d7efcccc0"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.7"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # Ensure the declared `openssl@3` dependency will be picked up.
    # https://docs.rs/openssl/latest/openssl/#manual
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    ENV["LIBGIT2_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_match "Failed to read config", shell_output("#{bin}/prr get Homebrew/homebrew-core/6 2>&1", 1)

    [
      Formula["libgit2@1.7"].opt_lib/shared_library("libgit2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"prr", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
