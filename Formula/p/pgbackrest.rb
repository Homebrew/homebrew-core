class Pgbackrest < Formula
  desc "Reliable PostgreSQL Backup & Restore"
  homepage "https://pgbackrest.org"
  url "https://github.com/pgbackrest/pgbackrest/archive/refs/tags/release/2.54.2.tar.gz"
  sha256 "f4d21dd8079c0c5255122530b166bebbf48b3d4361b14d6094197809ffb48f98"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "0079ce5ea11175cc717d7de39e95e40f6c27467a32592c25695067e2b62ce7db"
    sha256 cellar: :any, arm64_sonoma:  "908047fb0cd421af0f9bca8ebef4855f8442e9a027b238a2f305232dfef58419"
    sha256 cellar: :any, arm64_ventura: "06e35c096155ef777b63ab8546434553faae37ca8163fd6b4a656a25db9c1200"
    sha256 cellar: :any, sonoma:        "0c97b5bf0b4a530fa7616f8bd720b46c321ff58ec90adaeb97af33fe6455fafa"
    sha256 cellar: :any, ventura:       "38dc79cb0a755a5401dab40938e44753fd525283f1340248df51bc4aa3e653ce"
    sha256               x86_64_linux:  "26b7b370dc188c4ef542705baf1774243a6bb9073f6f7a1155cdf3d403b10ba4"
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
