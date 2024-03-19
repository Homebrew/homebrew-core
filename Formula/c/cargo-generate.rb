class CargoGenerate < Formula
  desc "Use pre-existing git repositories as templates"
  homepage "https://github.com/cargo-generate/cargo-generate"
  url "https://github.com/cargo-generate/cargo-generate/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "520e7a98bf82f368e911c14e774f8ef16a4c8ffd785d492c9d518ee563dc3864"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cargo-generate/cargo-generate.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4aaed5b5dcc9685991545f0a2cf0207a4dfa59a3947eca7e929bbf76f684b9f4"
    sha256 cellar: :any,                 arm64_ventura:  "b24e5cbfc6b5270397cb7e26e66d17bb4d544fe50d7df548b19fe99c1984c86d"
    sha256 cellar: :any,                 arm64_monterey: "2a636dafbd4b5a6c73c5ca35ff8eb8495980cfecb6424a801b1f3d87d7a0c2ce"
    sha256 cellar: :any,                 sonoma:         "f4b35acef951016e8d65fc70960c440429d1a44b25915f16df0ac2d54d1b7957"
    sha256 cellar: :any,                 ventura:        "1ed8bf8acf2ebcf3078c42ff0be585862ad0ec577d541431730b26d16a7e90d2"
    sha256 cellar: :any,                 monterey:       "fb88a64a25375a2e6bec59eacda72e9677f9aa6ab89f46b0e64ead49e9acdc26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1e1aba80b07b271e2815819edb2118661cda55962dbd66e61de8570ae157531"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
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
