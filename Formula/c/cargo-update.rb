class CargoUpdate < Formula
  desc "Cargo subcommand for checking and applying updates to installed executables"
  homepage "https://github.com/nabijaczleweli/cargo-update"
  url "https://github.com/nabijaczleweli/cargo-update/archive/refs/tags/v20.0.3.tar.gz"
  sha256 "379920d1b124cf58865258be0cef3da6199da9de0705d6c31c41eda862ce2138"
  license "MIT"
  head "https://github.com/nabijaczleweli/cargo-update.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c880f395a198994817ad4b735105368a99b40d0729fde242a2e7f43d4031cd15"
    sha256 cellar: :any, arm64_sequoia: "2d12c86eb685b07bba26ec8008e2afc9923a8f6fcad044d212701b1920410d77"
    sha256 cellar: :any, arm64_sonoma:  "e22f4f67f2ad18a658983165c12764f28becb1d22f239f301c5b409326b61429"
    sha256 cellar: :any, sonoma:        "edd9d0432dda41e22ddb7919e01508d98a1ee8bd027996250cee78dce50f6eab"
    sha256 cellar: :any, arm64_linux:   "a8d7b51611d0f6976c706ea3fffaddd06a22be23a4d10d78bbeab8d04563e781"
    sha256 cellar: :any, x86_64_linux:  "0eb99eb8eaa95f43c658ae15820a9c5e2d566f0f767edc390117091474f921c3"
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
