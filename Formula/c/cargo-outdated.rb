class CargoOutdated < Formula
  desc "Cargo subcommand for displaying when Rust dependencies are out of date"
  homepage "https://github.com/kbknapp/cargo-outdated"
  url "https://github.com/kbknapp/cargo-outdated/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "dca410981933dff2021e4c7606c6a8aeb13bf67ed9efed6068cb8d6befab3b69"
  license "MIT"
  head "https://github.com/kbknapp/cargo-outdated.git", branch: "master"

  bottle do
    manifest_sha256 "40ea37625b85fef165dd8464d4f0f9a1fc819b65d128166810c44917bbe1ad42"
    sha256 cellar: :any, arm64_golden_gate: "b0233d4cc8999d145797766b25ffac154766fd73febcdf97454a8e2071234745"
    sha256 cellar: :any, arm64_tahoe:       "a4ecbf8d0b8c87daf3f8918f81ed9b0e743a4149ff984eff2e77c04444bdbefa"
    sha256 cellar: :any, arm64_sequoia:     "793a94c7c6a093a98deb1ccfcd636ced789122e545980793637f66308c2872ec"
    sha256 cellar: :any, arm64_linux:       "45fcd509c78705e1340d100860492fdb75d06caaf78281241550ac6f75b6d192"
    sha256 cellar: :any, x86_64_linux:      "b2ee2cf3ae25bcd82db4c8f44d368cd4ba8614c71d5d9604277750c3a24b5d85"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "libgit2"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = dep("openssl").opt_prefix

    system "cargo", "install", *std_cargo_args
  end

  test do
    require "utils/linkage"

    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
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
      formula_opt_lib("libgit2")/shared_library("libgit2"),
      dep("openssl").opt_lib/shared_library("libssl"),
      dep("openssl").opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"cargo-outdated", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
