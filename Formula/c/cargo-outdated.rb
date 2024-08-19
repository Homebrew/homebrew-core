class CargoOutdated < Formula
  desc "Cargo subcommand for displaying when Rust dependencies are out of date"
  homepage "https://github.com/kbknapp/cargo-outdated"
  # We use crates.io url since the corresponding GitHub tag is missing. This is the latest
  # release as the official installation method of `cargo install --locked cargo-outdated`
  # pulls same source from crates.io. v0.15.0+ is needed to avoid an older unsupported libgit2.
  # We can switch back to GitHub releases when upstream decides to upload.
  # Issue ref: https://github.com/kbknapp/cargo-outdated/issues/388
  url "https://static.crates.io/crates/cargo-outdated/cargo-outdated-0.15.0.crate"
  sha256 "0641d14a828fe7dcf73e6df54d31ce19d4def4654d6fa8ec709961e561658a4d"
  license "MIT"
  revision 1
  head "https://github.com/kbknapp/cargo-outdated.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "94522bad259cf98624503bd1c36b359489a4e3e80e88892f28619d9edffe3287"
    sha256 cellar: :any,                 arm64_ventura:  "ec799ae4a8928ead673a50feec7067a5e0568c96fe6c862b0cb9535adc1dadac"
    sha256 cellar: :any,                 arm64_monterey: "e639384993b506125e86d0059712187857c328a944bd096ad32889865b35be2e"
    sha256 cellar: :any,                 sonoma:         "414ac82417f8b68cf77b882cc95b40de2a4a7a29a78f1e34111b4e4d54b05982"
    sha256 cellar: :any,                 ventura:        "1c0734e31857ad16ec0b49bc471aa33b4c8a3c83ac26613f665300e1538bdcad"
    sha256 cellar: :any,                 monterey:       "da4b0dce1d17bd596a0ac310407782ccab9c27e91edcd487f52c94c8e4a491f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37d1ad865261d4ed2dd5e3b19f3f843aa5e27fed0e3126b628417c6c9ca3d9e3"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "libgit2@1.7"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
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
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

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
      Formula["libgit2@1.7"].opt_lib/shared_library("libgit2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-outdated", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
