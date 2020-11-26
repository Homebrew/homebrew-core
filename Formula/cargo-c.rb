class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.6.18.tar.gz"
  sha256 "f6611f9d6914e6972bf9544064f9306a71d1cfb4bc8971e85415588770b81f35"
  license "MIT"
  revision 1

  bottle do
    cellar :any
    sha256 "c3805ead7fd6e6a6244a53b574e8a279625577342620b8fc3bf7f8c6756ea680" => :big_sur
    sha256 "d3244935c16570d258b5380bed6cc7d965d84ab7af38a6cbc33b4cce2b83ea5d" => :catalina
    sha256 "d1e130b9182ba1881d61b22a89a7bd30e4ed74e57cb04f6036000179d5fdc5e8" => :mojave
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
