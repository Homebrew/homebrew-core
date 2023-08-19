class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2023.8.14.tar.gz"
  sha256 "4549747e6a87cb745d74e357e20e7d727efdc7d37175e3c173bc67af292ef262"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f63ede3950840582a0d7c25b208e75f9aeb234c6a8e7a7c4f4fbf295782bbdbf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0eac78891f92a46d6df8e072d795d997284a854ab93ef5c8dbb098d7c3f85bb9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99b636dfb604399eecd4d5fbc29334539c377df5aac897a21916bb656d45652e"
    sha256 cellar: :any_skip_relocation, ventura:        "1cf1875ceca25ac1946de72aa176248e20b70818bcdb68281bdd4a870fa3394e"
    sha256 cellar: :any_skip_relocation, monterey:       "808d1bda6de8a212b1ccf2b86a4bb1597d6654ecdf0b2faaa86b005ca3a1d654"
    sha256 cellar: :any_skip_relocation, big_sur:        "6043a5d2143eb0e945e7594a2b14d31e3ec723f6d83622121387d780097e57be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bf76141d40b8f991279710501ed3dea522e7d0d41ae6308b342b5cc8e6c73fd"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
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
    system bin/"observer_ward", "-u"
    assert_match "0example", shell_output("#{bin}/observer_ward -t https://www.example.com/")

    [
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ].each do |library|
      assert check_binary_linkage(bin/"observer_ward", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
