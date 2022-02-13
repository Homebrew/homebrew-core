class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.9.8.tar.gz"
  sha256 "7c649061826e0ad3c2c8735718f4a0c4afd12eed9b9fdc5fe59e34582902e1c5"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ad2f1bf8acd796564d2b9f8e806c3a7bc89fe9f3581402fdfe1c543c8ede2db5"
    sha256 cellar: :any,                 arm64_big_sur:  "687157ee0c385362844ca293e3b6eed5ec1ff9e294e30200f6d23e2ac10b1e3e"
    sha256 cellar: :any,                 monterey:       "48a923cebe350085446cc69e5c0d3ce4ae21615d330673e18ef5634957987aed"
    sha256 cellar: :any,                 big_sur:        "26d49741af3e6d22b61e5b2ffceeffb0dd856cd250ea3d6dc63f95c1f514cf87"
    sha256 cellar: :any,                 catalina:       "de7388c4b1b3c02697a77eed71216dfea790380bd282067faa6e7d48222cbead"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcc381cec156020f08fae8cdeebe6f8877de438bd785478907ffce8bdbff3399"
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
