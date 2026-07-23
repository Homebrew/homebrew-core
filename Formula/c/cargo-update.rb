class CargoUpdate < Formula
  desc "Cargo subcommand for checking and applying updates to installed executables"
  homepage "https://github.com/nabijaczleweli/cargo-update"
  url "https://github.com/nabijaczleweli/cargo-update/archive/refs/tags/v22.1.0.tar.gz"
  sha256 "0e627270c963403ee1157c8dcb1679f779e261aaa4c23ccd9693fabaa5400509"
  license "MIT"
  head "https://github.com/nabijaczleweli/cargo-update.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "78073f48533aadb2845a440306e47b4ea12b8f9bdb9754b369eee5053c1fe1ea"
    sha256 cellar: :any, arm64_sequoia: "acdec9d900014f208836cbc9b24ddfb34f95e98cc200e411443559cdbb0bb703"
    sha256 cellar: :any, arm64_sonoma:  "2fd92d8e796ebc92577fdbb38e0f29d9dd03f702786489ad99c5ddf103619dd7"
    sha256 cellar: :any, sonoma:        "359b55df81b3c58d97eab19350826892f4ccc365950634d292136378dd483695"
    sha256 cellar: :any, arm64_linux:   "711b811b6d1561bfc4caf4b594c849b566d04cc3ab94087e5f8c0da7f896fa56"
    sha256 cellar: :any, x86_64_linux:  "28bd2940ce20c4d9a2b2905830115c4b835e4569a07ffe02af27bfff6c9478ed"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    assert_match version.to_s, shell_output("cargo install-update --version")

    output = shell_output("cargo install-update -a")
    assert_match "No packages need updating", output
  end
end
