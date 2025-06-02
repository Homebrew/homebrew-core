class Pgbackrest < Formula
  desc "Reliable PostgreSQL Backup & Restore"
  homepage "https://pgbackrest.org"
  url "https://github.com/pgbackrest/pgbackrest/archive/refs/tags/release/2.55.1.tar.gz"
  sha256 "5f050ad751feb5b506cf3c58a5cf1674a7b502328abcb50b37756175f80990e9"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "14f05c57dcf96a4e1096fe8b9b924d1439cd21ccb4737d334232235b091ed3da"
    sha256 cellar: :any, arm64_sonoma:  "116313dd70a612c5cfdb47033069bd3912a32f8cfb5fee45d1ddc3e277cd1fd1"
    sha256 cellar: :any, arm64_ventura: "5fae48146afd2f5db6e36083779a9a8bdca40630513d5515f5ad0be14469dddc"
    sha256 cellar: :any, sonoma:        "4c2a1572e6c95fb8050f7719d756b8836f0f63be8d90e02226214d8f0544d3b9"
    sha256 cellar: :any, ventura:       "48c571b082a3c402fa3e220494dba9c65aef820c1cc018828a227e3d76b1e0a0"
    sha256               arm64_linux:   "9ccbef3723ec786682bf644f6e7eaf6f4f9b466816721e8647a23fe74247e580"
    sha256               x86_64_linux:  "36fc1f723b68db34d8c9a0acf8bffb632bd12d1eb5453532a10c7e6989ada54e"
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
