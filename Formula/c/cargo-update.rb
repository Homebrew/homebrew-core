class CargoUpdate < Formula
  desc "Cargo subcommand for checking and applying updates to installed executables"
  homepage "https://github.com/nabijaczleweli/cargo-update"
  url "https://github.com/nabijaczleweli/cargo-update/archive/refs/tags/v18.0.0.tar.gz"
  sha256 "cfa56d6c5fb2d7d1536efb4765031731fe70bf1a8246757a7a9d6a4a046e640f"
  license "MIT"
  head "https://github.com/nabijaczleweli/cargo-update.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3c60c3bea3d800efc1f2ac66d117a4544b31d9e92ccde2e60e65e534ac16754b"
    sha256 cellar: :any,                 arm64_sequoia: "56a8338b18b4980b7c1744cc2b5fbbf44078489ab9ef452c4d7aa9090322d142"
    sha256 cellar: :any,                 arm64_sonoma:  "9d69c9a9d118e83a99b6ac038ae9ba8221655fe55c3e4b12e4827e74f9fc358c"
    sha256 cellar: :any,                 arm64_ventura: "ce025543bc177fe07820d3b64a55664d61945fa2f17b2502b2c4cf4d64fefdf4"
    sha256 cellar: :any,                 sonoma:        "2d3265e8c1ebf47db152196dc0203f8a180c914daa6065cc28f8e2183c14c43d"
    sha256 cellar: :any,                 ventura:       "521005f06bc948e75d409be52a2323a7e18bba69fafca15c793890b6295dadba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6b411ecebb18145799d683784ab80492f737d4c392b3327ee1cc31e053eb59d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32753c7f3beb9525ee63d56bbf41c2bee392f17f3df1cbff1569f4256b863afa"
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
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    assert_match version.to_s, shell_output("cargo install-update --version")

    output = shell_output("cargo install-update -a")
    assert_match "No packages need updating", output
  end
end
