class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.7.1.tar.gz"
  sha256 "4139690718894606e02a76e857a88f4b7482181915644aa4a385aad9f02f3573"
  license "MIT"

  bottle do
    cellar :any
    sha256 "cba2140415ab264d8be8f471ac06a9ff12e270f6d25475663096b6302c03e5fe" => :big_sur
    sha256 "a591286629fc88d60cfec3a41188582cf67652d9f2acd7db4c564bb99b70c01a" => :arm64_big_sur
    sha256 "13999f706b3bba61b2380ab26ddf327e7110816f72bb0d5c1454d6571b2fe361" => :catalina
    sha256 "4f6e019268d3263fc50faff74c47fb1559ae3fcbe319f3263deb7a4c8aba86a3" => :mojave
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
