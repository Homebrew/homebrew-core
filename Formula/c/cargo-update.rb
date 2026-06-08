class CargoUpdate < Formula
  desc "Cargo subcommand for checking and applying updates to installed executables"
  homepage "https://github.com/nabijaczleweli/cargo-update"
  url "https://github.com/nabijaczleweli/cargo-update/archive/refs/tags/v20.0.0.tar.gz"
  sha256 "7e9898ae686fe64c4cf75be5c4e9e6d5f6141371182a12e4bdaa806cfe321806"
  license "MIT"
  head "https://github.com/nabijaczleweli/cargo-update.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fe4438edd2b0ad384e385bfbb32f460ccad51413b7f80c0a1024ea194aaf31a5"
    sha256 cellar: :any,                 arm64_sequoia: "4892acbd6dcb1f707c16d96e20c38bb99c5e58eedec66a3136cdb7e063247f26"
    sha256 cellar: :any,                 arm64_sonoma:  "f2d8d6e3acd8dfcbaacae64d47c2f5c62a4d9c8ab56d714b58e34c147904ca17"
    sha256 cellar: :any,                 sonoma:        "54b3b6fdffd16d8801b31091058a99f3868f824620686e7e875067744fc8951a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "983090fde7ee534126ef080f10eac11643ca76b4ff40d4422c5bd809d22265c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd00fe026dc90276e90e94c76c7e7e2bcd3f5cc361e3321f72bfa67eed3ce9cf"
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
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

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
