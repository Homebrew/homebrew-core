class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.9.4.tar.gz"
  sha256 "8965b1381f2c6fd040a1b930bebf8d1c12646dd7be43d76a23bcc0edf37887d4"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "110ee7d5ae0d6d2610ed352993fb704ae9581d7d56daa28b8a59b7364c02f0c6"
    sha256 cellar: :any,                 big_sur:       "c0d11e28fa2082d5768ed4cbe28bcf7cbf56ea615a408eeb48be5a003f9a9e02"
    sha256 cellar: :any,                 catalina:      "951d84ba87b2fc74f91fbf2b020edf3184cdd1dccdbf57216e0b8f50877d67d7"
    sha256 cellar: :any,                 mojave:        "dc2b9506ad82ca0e3ea50052cae0f2eaf30ffc8499f22385f05743468a967be5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0b777a6d218472ddaadbec1efbec5e1debbfbe2281ed6147214c7dec62c0641"
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
