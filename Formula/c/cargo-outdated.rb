class CargoOutdated < Formula
  desc "Cargo subcommand for displaying when Rust dependencies are out of date"
  homepage "https://github.com/kbknapp/cargo-outdated"
  url "https://github.com/kbknapp/cargo-outdated/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "6c1c6914f34d3c0d9ebf26b74224fa6744a374e876b35f9836193c2b03858fa4"
  license "MIT"
  revision 1
  head "https://github.com/kbknapp/cargo-outdated.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "acdcb7ecd3db5e0b5a0d279d33f3f308d9180a9f434ff4f01f2ad2dd075db7d0"
    sha256 cellar: :any,                 arm64_sonoma:  "d54403dea4e7474a13d95f37c4df3cf620391e920c72ddc814b614abc15e31d3"
    sha256 cellar: :any,                 arm64_ventura: "63f180c145002e1906a6cb979b706167b51ad49d1a5d04aa4e9b47722a2ca306"
    sha256 cellar: :any,                 sonoma:        "fe719091f6604bb307a67e5dc40a1834a2c6c00be1d709d0b39e608e34eb62f9"
    sha256 cellar: :any,                 ventura:       "9969c6842f7ada5d69bbd34cf5922b4ae2b5d43814234b0b9c6c29401977bed8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "394f86740d2621697b1bcf853741e7d35f37934dbec121896e139fe5ca1a897b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16e44c82524d478341c722f1837ebb9d82807fb556e2074a0675e44bfff7b79f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "libgit2"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  # libgit2 1.9 patch, upstream pr ref, https://github.com/kbknapp/cargo-outdated/pull/417
  patch do
    url "https://github.com/kbknapp/cargo-outdated/commit/67213eb08b60f402d543d4b2aeb79f813f1ade5e.patch?full_index=1"
    sha256 "712df30c8293327848e5156df8524f60fb425c9d397f954d88c5d31c36189a79"
  end
  # cargo 0.87 update
  patch do
    url "https://github.com/kbknapp/cargo-outdated/commit/9c766bf49d37fc2d3fc19ee6b06c4b022c7138a1.patch?full_index=1"
    sha256 "5d3d1361804eb64272eb8d88110eeafbf998eff4262687989164b0d32e0c2225"
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "cargo", "install", *std_cargo_args
  end

  test do
    require "utils/linkage"

    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [lib]
        path = "lib.rs"

        [dependencies]
        libc = "0.1"
      TOML

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
      assert Utils.binary_linked_to_library?(bin/"cargo-outdated", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
