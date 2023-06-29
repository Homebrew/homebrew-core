class CargoOutdated < Formula
  desc "Cargo subcommand for displaying when Rust dependencies are out of date"
  homepage "https://github.com/kbknapp/cargo-outdated"
  url "https://github.com/kbknapp/cargo-outdated/archive/v0.13.1.tar.gz"
  sha256 "571910b0c44f0bcf0b6e5c24184247e4603f474c7bde5f0eaa1203ce802b4a4a"
  license "MIT"
  revision 1
  head "https://github.com/kbknapp/cargo-outdated.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a091b1d33b8993cccaadd3226b18e47123387abf7926d0077c457942e70b7dfe"
    sha256 cellar: :any,                 arm64_monterey: "20e674b341efba24dd8c4d8e5b35e138d348f5f62d0a0883ef348f44f540ef54"
    sha256 cellar: :any,                 arm64_big_sur:  "2b811bb18b558bbe8290c62f9b3c8de03305a8ef80f4361f7f98aa8ba6f27546"
    sha256 cellar: :any,                 ventura:        "488b9c21900f86bce7ec670eb513bd1a567e3d5fec37cfa2532a8bf6912f2c5e"
    sha256 cellar: :any,                 monterey:       "6682da0e97842b793ec175289492b8e53c9943d0fc5cc34a8de99f29d2db3e47"
    sha256 cellar: :any,                 big_sur:        "3c990f4910559e35b00487de1ed368f14f047c6ce9d18597fe2bedcd224da740"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f869e828ca53e03d6b976af8bd71cba0c5b558713b80b8bf5703f2b0049048d2"
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
