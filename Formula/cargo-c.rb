class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.9.11.tar.gz"
  sha256 "a3e9471e80e7963ab1d8aa09d0c8ce4d76509346569d89fc86848dd2a9d20d43"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1784aa937f0001906e5290d39f84b647ba02df680d0b72d0fa302ccf0869ca46"
    sha256 cellar: :any,                 arm64_big_sur:  "214d7b2ab916d0816d07f358cdf3662a89d5bf478bfbccaadc0c02db47e64e8d"
    sha256 cellar: :any,                 monterey:       "36c1ae8af14573edd6bcfc99fbe9ec4968412cb730fa3f152d5163c088278bda"
    sha256 cellar: :any,                 big_sur:        "d6984f628fb4223b33a76582a865430434a171fe6dbf765b247a3e94bccecb21"
    sha256 cellar: :any,                 catalina:       "a0f0f62233a6090614433866685338c0ec1e1dae3a80237dc03492092dbbbf1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87525f490f66a6ee7a9e955465359f2a388ffcb53e573de5089d12fad7df902b"
  end

  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    cargo_error = "could not find `Cargo.toml`"
    assert_match cargo_error, shell_output("#{bin}/cargo-cinstall cinstall 2>&1", 1)
    assert_match cargo_error, shell_output("#{bin}/cargo-cbuild cbuild 2>&1", 1)
  end
end
