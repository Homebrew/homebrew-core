class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.6.15.tar.gz"
  sha256 "528d2a66d1b866e2d860e42a0c9184b75873539cb86ece948c00f4b3bd5028fa"
  license "MIT"

  bottle do
    cellar :any
    sha256 "e037c350cdc6ce12d915666c8a90337517721705e63cf0168ef5455f6feb9f07" => :catalina
    sha256 "41c88b3a42f6112aa80a1bc743a14b7e3123e307568144ab1693e5c12d764829" => :mojave
    sha256 "4e5794919e094c168c6974278c5d7bb5c553e4ba0da42ad153b2bf189e28ed7a" => :high_sierra
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
