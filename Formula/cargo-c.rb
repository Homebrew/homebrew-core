class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.6.18.tar.gz"
  sha256 "f6611f9d6914e6972bf9544064f9306a71d1cfb4bc8971e85415588770b81f35"
  license "MIT"

  bottle do
    cellar :any
    sha256 "fec7abf8d74b71de699fd592761de2e8564317f24e4958a136aaa9957c111fd0" => :big_sur
    sha256 "048ecb51468dd2677f32d4509d531e370daf2dcfd4b2528c56a7d26955ca0596" => :catalina
    sha256 "4d3e099322d61ecb42285d1c08b9b5ba97727a958d942e53e1a18600c42dc2d7" => :mojave
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
