class Prr < Formula
  desc "Mailing list style code reviews for github"
  homepage "https://github.com/danobi/prr"
  url "https://github.com/danobi/prr/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "3c32911854a33a1a7870382db0e759923315ec943b5d43dec42d751820473094"
  license "GPL-2.0-only"
  head "https://github.com/danobi/prr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a41eaf83c87805e346322d8b5d70b2510b121c4a12fc8afea76d0dc422605d32"
    sha256 cellar: :any,                 arm64_ventura:  "3e372a872a907dae516ced9fc6b9249d91393ce9e7406656f2db611afb921bfb"
    sha256 cellar: :any,                 arm64_monterey: "dd4711d7fb1e746f81aa958d359feaded9beb6b0c1b8fb472cc73f96e969236a"
    sha256 cellar: :any,                 sonoma:         "c5f8b4fff81e8e58789786b419b09fa8727ca33a7ccb1857cb2cf168c8dc6423"
    sha256 cellar: :any,                 ventura:        "f709f6934727a3cb9626883f698a03dc1e818a2937266de8cd5087d0fb99f57e"
    sha256 cellar: :any,                 monterey:       "eaff2deac7e7b0fb1bfa75d352eac30391fbc85a07e437549543a843ae3111fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c95b6520f8088895a53baf6b32b335d513d4deb0e2c021195db43476e5311f6"
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
