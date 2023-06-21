class CargoOutdated < Formula
  desc "Cargo subcommand for displaying when Rust dependencies are out of date"
  homepage "https://github.com/kbknapp/cargo-outdated"
  url "https://github.com/kbknapp/cargo-outdated/archive/v0.13.1.tar.gz"
  sha256 "571910b0c44f0bcf0b6e5c24184247e4603f474c7bde5f0eaa1203ce802b4a4a"
  license "MIT"
  revision 1
  head "https://github.com/kbknapp/cargo-outdated.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "94549d70982775303f6c056336080a13432051ab9623a91cbcf66f9bea555987"
    sha256 cellar: :any,                 arm64_monterey: "f4f3924b3e86d7681c76080875fca32157eb0bece4c539edb00ecb576bcada23"
    sha256 cellar: :any,                 arm64_big_sur:  "ceb5304cdccc0446bfd5623c08898c8f2238f27aba17ef691afb15134bb16058"
    sha256 cellar: :any,                 ventura:        "e498c2e69bc4c736925bf9fad65a7a374e957fe0e885c37df2766e500e07fb0e"
    sha256 cellar: :any,                 monterey:       "907e1ba63c1f6f685a93b8281768725aeffc7fc5c5981662ff89fab82e415a78"
    sha256 cellar: :any,                 big_sur:        "f0e1d11511b61334bdcc8426218ac7b21a106f10328f48baa50fe599368886e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "712a0937a31535b4c70b9b67f9f2f8e797f86ab6574c755cb17736a639c670eb"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "rustup-init" => :test
  depends_on "libgit2"
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    system "cargo", "install", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    system "rustup", "default", "beta"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [lib]
        path = "lib.rs"

        [dependencies]
        libc = "0.1"
      EOS

      (crate/"lib.rs").write "use libc;"

      output = shell_output("cargo outdated 2>&1")
      # libc 0.1 is outdated
      assert_match "libc", output
    end

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-outdated", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
