class CargoGenerate < Formula
  desc "Use pre-existing git repositories as templates"
  homepage "https://github.com/cargo-generate/cargo-generate"
  # TODO: check if we can use unversioned `libgit2` at version bump.
  # See comments below for details.
  url "https://github.com/cargo-generate/cargo-generate/archive/refs/tags/v0.18.4.tar.gz"
  sha256 "830c9a6bc6350f47e854260291d7303b8058659f8e03b85894f5636ec2d69b17"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/cargo-generate/cargo-generate.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f8604cdaa3abbad85cebf35c31ea9094cd485846db6a1e7c1501c347a0c887a7"
    sha256 cellar: :any,                 arm64_monterey: "5531f9d28f0987b8df1618c14756c3058249fdeaf875e9f062a5d5c2ed93e8c1"
    sha256 cellar: :any,                 arm64_big_sur:  "bea38c9c69707163bdcfd676dc4fc6e0c0270b332ccaa108636e84053a8f3666"
    sha256 cellar: :any,                 ventura:        "74e5a5029a89b5b8473eac07d20af0419b7480b00d818137f3cc81cee26ebf1a"
    sha256 cellar: :any,                 monterey:       "e0281cd735b23577defc2f3a4c152aac138de326682e6f7c72cfea90395af7f4"
    sha256 cellar: :any,                 big_sur:        "a4a4c91e2797eccb3d4ea68090e15d10e97849275a62cd158293712780711bce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d19aecb6fd248226f867516b30c395efce81544550d7a343ba3dbd94213f51f2"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  # To check for `libgit2` version:
  # 1. Search for `libgit2-sys` version at https://github.com/cargo-generate/cargo-generate/blob/v#{version}/Cargo.lock
  # 2. If the version suffix of `libgit2-sys` is newer than +1.6.*, then:
  #    - Migrate to the corresponding `libgit2` formula.
  #    - Change the `LIBGIT2_SYS_USE_PKG_CONFIG` env var below to `LIBGIT2_NO_VENDOR`.
  #      See: https://github.com/rust-lang/git2-rs/commit/59a81cac9ada22b5ea6ca2841f5bd1229f1dd659.
  depends_on "libgit2@1.6"
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
      Formula["libgit2@1.6"].opt_lib/shared_library("libgit2"),
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
