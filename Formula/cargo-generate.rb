class CargoGenerate < Formula
  desc "Use pre-existing git repositories as templates"
  homepage "https://github.com/cargo-generate/cargo-generate"
  url "https://github.com/cargo-generate/cargo-generate/archive/refs/tags/v0.18.3.tar.gz"
  sha256 "e44e021dbc83cc862e4f52fce76ed6cfab0cf08d74505fe177bec048f981ac9b"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/cargo-generate/cargo-generate.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f1423eba17a969331a6245be5750dd057993c96dd7d3f88e6e10f3775522bb44"
    sha256 cellar: :any,                 arm64_monterey: "872007cf7741a8c95e571d06cae772ce30bf4b05792cb38cc3070290b88a0657"
    sha256 cellar: :any,                 arm64_big_sur:  "a279ff568f299917443c319f901544faf7bc49e067758e6b011710a286dc95af"
    sha256 cellar: :any,                 ventura:        "83f7d54dc2ca09ae6696e2e58e5e9601c2d4ef8404630c9772ea7a48b1145707"
    sha256 cellar: :any,                 monterey:       "99a7741c22c61bf9f48f0b0e1b565231b35f4a1f52a5836bc0f86d1dd490ff8f"
    sha256 cellar: :any,                 big_sur:        "6f7b3ce671653d4f4660943708f41d49846d0aef7f4018cdf2d076d5c96627ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7100287872bf0fabcf2a03cfa891eb83c63a780c84d8b03f07b9ba69ae6711bc"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  def install
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", "--no-default-features", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_match "No favorites defined", shell_output("#{bin}/cargo-generate gen --list-favorites")

    system bin/"cargo-generate", "gen", "--git", "https://github.com/ashleygwilliams/wasm-pack-template",
                                 "--name", "brewtest"
    assert_predicate testpath/"brewtest", :exist?
    assert_match "brewtest", (testpath/"brewtest/Cargo.toml").read

    linked_libraries = [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ]
    linked_libraries << (Formula["openssl@3"].opt_lib/shared_library("libcrypto")) if OS.mac?
    linked_libraries.each do |library|
      assert check_binary_linkage(bin/"cargo-generate", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
