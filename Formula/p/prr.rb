class Prr < Formula
  desc "Mailing list style code reviews for github"
  homepage "https://github.com/danobi/prr"
  url "https://github.com/danobi/prr/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "7ad7a14f6bd6edd253afb75a95b244a7a578c66099121441547295fc096f199a"
  license "GPL-2.0-only"
  head "https://github.com/danobi/prr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5aaf380e9ffdd9452fd1c72c109d61529ee0f1ab146d14bec45d14a8659b99be"
    sha256 cellar: :any,                 arm64_ventura:  "354917419eb2535e1bee4db2255b5591bcbb1c0b33dc49d0ff16d1e5b0cf5237"
    sha256 cellar: :any,                 arm64_monterey: "4a134879bbf6a70bad4beafd27d27b5cc435c6b8d0d984d467cdb5a0abe60011"
    sha256 cellar: :any,                 sonoma:         "74ba628b42b1581d8482c9ec4f3c5286c58a020aa678d3c3e2f24c274503af15"
    sha256 cellar: :any,                 ventura:        "00155dac3ff7f68c8248523ae2a38dbc4ad9fc078ef2b0b5057595b45cea472a"
    sha256 cellar: :any,                 monterey:       "3a4c2d836f857f12dfffcba7dfe641cef5b5c439f6f84bca30168b808d0e5365"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6d571fc884e4190deabcb21ff287bdc5279ba428604637085800233c10acd98"
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
