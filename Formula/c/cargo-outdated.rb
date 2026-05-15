class CargoOutdated < Formula
  desc "Cargo subcommand for displaying when Rust dependencies are out of date"
  homepage "https://github.com/kbknapp/cargo-outdated"
  url "https://github.com/kbknapp/cargo-outdated/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "ea6592c08d4e8ea53aa0251cbbfbf8ad2b2167f794cb9599715eecb3653507f2"
  license "MIT"
  head "https://github.com/kbknapp/cargo-outdated.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6174085b6cd0d46cd1be2c6dda1a24a0f7bcd4e98c362808c63e09d0c11bf3bc"
    sha256 cellar: :any,                 arm64_sequoia: "57f2a20781ae0cbfcf3e279725f528d12d808d008876e0bcccf5cda173eafc1f"
    sha256 cellar: :any,                 arm64_sonoma:  "c77702c3d4da76762864ace24b8b25318bd732b95019471c061b6188892c38bd"
    sha256 cellar: :any,                 sonoma:        "6afd5d52a700fd64b1f613980c399f08a05ccfe5f38072f42bfc438bd89a826f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f4b8afc5760e243f583e60f81e11cd92a9819a14d6d00bfdc7125fcede1b035"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d8f21cc13aba011e544f746cb9096799337c335ff8796586c23163bab069f1c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "libgit2"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
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
