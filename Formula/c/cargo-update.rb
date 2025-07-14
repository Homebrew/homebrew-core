class CargoUpdate < Formula
  desc "Cargo subcommand for checking and applying updates to installed executables"
  homepage "https://github.com/nabijaczleweli/cargo-update"
  url "https://github.com/nabijaczleweli/cargo-update/archive/refs/tags/v16.3.2.tar.gz"
  sha256 "49e016c8189b779af4663c62c2b304f770e5a4358ed5348ae61e68bf3034a689"
  license "MIT"
  head "https://github.com/nabijaczleweli/cargo-update.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "279ba819692bbfb26927cb66eaea9ee94c3a1c2dbecce9b31d8886023a59202e"
    sha256 cellar: :any,                 arm64_sonoma:  "35d889b76f13d363f79fc26dbefe6b69220ff73f6de1ecf18b0f294c2a24d10c"
    sha256 cellar: :any,                 arm64_ventura: "5f5b973073dd127c5a98e3219aa54195323425a12b31ce7213f95c6b1486eedc"
    sha256 cellar: :any,                 sonoma:        "485de0cde1bb32d78ab7f225398400299710422cae890afbea146f0f267faa9c"
    sha256 cellar: :any,                 ventura:       "55911c64684590ec97f4e3920a44a5d74fe0ed7b73fe058c0c166423a0926356"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bac1f8e213a8d54f9c50e2368e964ca8c33496522dadcaa8b6787f893e5426f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd8311fec35573a77ed073b3f824f8c954d85008cb9e19e4d6e4cf0e2329e46a"
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
