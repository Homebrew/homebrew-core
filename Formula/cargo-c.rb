class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.9.13.tar.gz"
  sha256 "d7c5d6259798abac86a4c8c36884ae7f1591831e74fbd6ce87b7c5e953196f75"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6e93652a2ffee83bb27de3820ef9d769a0ccf20c3d68f3596899c4919ed45551"
    sha256 cellar: :any,                 arm64_big_sur:  "0fa49811fd55ba94c29281b9ae6c817503c9ea5df20ade4a081f874ad3e717c3"
    sha256 cellar: :any,                 monterey:       "0b2001787acfd389d2d995c66f31eaa85d6ebd74fc79fa48c4ff391aaa142c7a"
    sha256 cellar: :any,                 big_sur:        "11eb6d995320c1432f3275f30d686c1a7872ea98eaba6b35517819356aee1dfa"
    sha256 cellar: :any,                 catalina:       "e7611841ea0b21b4d3cb0134adf8a4e025d53b71a36698531802ca7e20f95a08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e682aba1d4ec144471bf3370cc99a64843488a1bf0c4fa6f6cf6e38a76e9d3e1"
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
