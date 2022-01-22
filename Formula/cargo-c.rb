class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.9.7.tar.gz"
  sha256 "eead78d26b4e5924e9d750f66f2fef4d706680927542d87c895178fc0be016f0"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5ae1cd6ceb4a4543e0ef39d009672fc05780386ccf1d03beff214ae44e06fdc4"
    sha256 cellar: :any,                 arm64_big_sur:  "be28ae9ff8df87545ab95d9c53be0d7746af621d0c7e845a4640f50fbc3026be"
    sha256 cellar: :any,                 monterey:       "9f0f50fc3e1f21c936ceb7c73b04345871d99fa899bbc346562686f0d11925d9"
    sha256 cellar: :any,                 big_sur:        "e6dc3290e2b3fe8fd5cd4a1c29456a95edbb67d4001ad6d4707944b6fb7ca8c8"
    sha256 cellar: :any,                 catalina:       "8cdd97b8ae42958bacb734174b5e89e7c9aaba8411030e6fafbfad01cc64b9e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d370f1ae18a77934ce43c6df29a26ee7d8086a412b2681c3bb0cdec22c36383a"
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
