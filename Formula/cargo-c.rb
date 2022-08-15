class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.9.12.tar.gz"
  sha256 "d700c6cc93d06c5ed7a887f51d87d47e88e783dfc1b28d00b951625c4d3ce509"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ec0969491f47fcf82816323c6239be4d9520d4ee602fe0d1f9e92549702ed8a9"
    sha256 cellar: :any,                 arm64_big_sur:  "1987e00c88facc77d9387c015d427496e346c95967ae4a3df6138ce2ee01e37a"
    sha256 cellar: :any,                 monterey:       "bbe163dbcc408dc479e7a9260ad22ad7c27cdc7b539ffa4e56a943f08f4bb045"
    sha256 cellar: :any,                 big_sur:        "a31b8069c6be51175472939fbae48de22a98ecf1e0277ccf569293fb9f0cef42"
    sha256 cellar: :any,                 catalina:       "f2e178ad84f81fae8db3ac7b74af10d1b0060e1ed7f66c731842b5d874753d10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e429a7020a9f66f9db925203659c6ccca959d1eb5aeadbc48c1f38389bd1510c"
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
