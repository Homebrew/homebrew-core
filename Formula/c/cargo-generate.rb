class CargoGenerate < Formula
  desc "Use pre-existing git repositories as templates"
  homepage "https://github.com/cargo-generate/cargo-generate"
  url "https://github.com/cargo-generate/cargo-generate/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "b1b5d0e76ed20c7167d52f8fde28716f35c817196697a01dec525e878300a942"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cargo-generate/cargo-generate.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c263fbbd893d9a22bad2c10b2c3f59504fb6ec55b959fc393cb658671998536e"
    sha256 cellar: :any,                 arm64_ventura:  "4c85136f212aa01a361a5a4fa05ff9164c5700b81fd1b59db752ba7c91dfa804"
    sha256 cellar: :any,                 arm64_monterey: "fcd00fcc6b3eae244d1245aa5568bea6db44e50e716e1b15b48900ebb45b4ef9"
    sha256 cellar: :any,                 sonoma:         "44cd9b22a7c0c4ec9b99055aeb51439f02153ad0bbd52f22e2cbdb2b37cc211b"
    sha256 cellar: :any,                 ventura:        "819d670d163667a25c9838beaf4a187e6eeb34e6e80b7152251c146a78b4f9a4"
    sha256 cellar: :any,                 monterey:       "9254aa6532b588cbc44003d1c31c40afdb2c548d0cab9bf242d484792ee6a2a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d325cae6644c3592749dba376e440ba725900ae1b039cca349e59dfb3178571"
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
