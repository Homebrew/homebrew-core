class Pgbackrest < Formula
  desc "Reliable PostgreSQL Backup & Restore"
  homepage "https://pgbackrest.org"
  url "https://github.com/pgbackrest/pgbackrest/archive/refs/tags/release/2.57.0.tar.gz"
  sha256 "d794519c0ecb4ec17f41c4267d07fe80ab6b3ac9cc1de5c7984887c5e6d7448a"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8a8c360967998cee0ae02e55a31a722ce42ce57d9a2cf66e7d9ffbfee4ef5b2e"
    sha256 cellar: :any, arm64_sequoia: "7998ebdb5fac0d09d13d88e764f4bbf1f01d95d651a689195e019a659b3d36c0"
    sha256 cellar: :any, arm64_sonoma:  "d7901e3a61b966084f86a8941e611cf423bf5a95029930faa63dcff1b3882e78"
    sha256 cellar: :any, sonoma:        "88390d24c0b4a788a38f8f10633a826f3784a6d70cd923cee61068bac9860c0f"
    sha256               arm64_linux:   "c5f14f2d2fc6b3251bfd16688a9b0df51f70ee281bc5b2724f277649fdbfce9d"
    sha256               x86_64_linux:  "c3c62af8aa93ded209ad328f0ea54b2bfbe2b22052d7fdf3894f83a9fbe08488"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libpq"
  depends_on "libssh2"
  depends_on "libyaml"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath(target: Formula["libpq"].opt_lib)}" if OS.linux?

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    output = shell_output("#{bin}/pgbackrest info")
    assert_match "No stanzas exist in the repository.", output
  end
end
