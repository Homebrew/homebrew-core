class CargoUpdate < Formula
  desc "Cargo subcommand for checking and applying updates to installed executables"
  homepage "https://github.com/nabijaczleweli/cargo-update"
  url "https://github.com/nabijaczleweli/cargo-update/archive/refs/tags/v16.1.0.tar.gz"
  sha256 "9173e0354eea95f5f6419c710467710b88c0b0a4562953bdfc4a82bfb125b8e1"
  license "MIT"
  head "https://github.com/nabijaczleweli/cargo-update.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "d6ccdb6406072e4557c05aaad243001c48094e00ca4033429ded4163a676429b"
    sha256 cellar: :any,                 arm64_sonoma:  "8c5d0979b2e76bd69c026de1b41f294645552ca9f5dadcea81065da4910995cb"
    sha256 cellar: :any,                 arm64_ventura: "c066f18bb4ce58400a43d03d87f27c40ed2d29d21b516e6be8c8e87221db9b22"
    sha256 cellar: :any,                 sonoma:        "272f21263ee5dd7930e5adefb688995f9bcba61ff647353ca575bce312cecf81"
    sha256 cellar: :any,                 ventura:       "5b3aaa05b5d5c51523fcf4c0ded1c0f838ecb4bef30def7471f68319e494f968"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15edf65d1ee7008ac0a4a4e66b7ca4f6f018f3a84327f9a509a36be5b1171484"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    assert_match version.to_s, shell_output("cargo install-update --version")

    output = shell_output("cargo install-update -a")
    assert_match "No packages need updating", output
  end
end
