class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.6.15.tar.gz"
  sha256 "528d2a66d1b866e2d860e42a0c9184b75873539cb86ece948c00f4b3bd5028fa"
  license "MIT"

  bottle do
    cellar :any
    sha256 "eed10c53d40a69b3e88813c3ae6ba68d2700b97dc17d00eba921ea0428070803" => :catalina
    sha256 "adf99c2d30d1c185ec499d365a4e3bf97964930fe344a552766427f256d38dde" => :mojave
    sha256 "3b74b6b64213270f376d7643e64825650d25fcda6d7ae9ef12ca15496d7a096c" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@1.1"

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
