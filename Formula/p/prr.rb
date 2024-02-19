class Prr < Formula
  desc "Mailing list style code reviews for github"
  homepage "https://github.com/danobi/prr"
  url "https://github.com/danobi/prr/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "7a08a329682d0f19b2479d34c1ef0a2dc3a2b7a1e9d4dd99b86dd8c4cdfd19b3"
  license "GPL-2.0-only"
  head "https://github.com/danobi/prr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3f851229212d42df72e92b61856ca829a28e93db5aeca1f2fda7b77f93c80d28"
    sha256 cellar: :any,                 arm64_ventura:  "981f6ca493dc407d4c65e670929a727aa2af5bd8e36736e0d68f8db11a148038"
    sha256 cellar: :any,                 arm64_monterey: "4c1163a6058f5914b49288a8eb9b176a0035c244bee176b837a4608285151dd1"
    sha256 cellar: :any,                 sonoma:         "5c438653bce8b96224bf77f4d11e2443ac63ce2e61e8edf01103fddbe3d7959e"
    sha256 cellar: :any,                 ventura:        "bb73d67e202011fc91316692fbb39ea4ea53dbbff4054126a262bedd381bb356"
    sha256 cellar: :any,                 monterey:       "482b747388f8083d96be5ac22b53b4a63b01fc93d54ea5cbba17cd4735678469"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8e74f1791c42fd7cdc032c98019da55b02ef4da2d12a32f4e1591b9c2ebe9e3"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
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
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"prr", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
