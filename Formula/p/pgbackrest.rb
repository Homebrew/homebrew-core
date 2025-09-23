class Pgbackrest < Formula
  desc "Reliable PostgreSQL Backup & Restore"
  homepage "https://pgbackrest.org"
  url "https://github.com/pgbackrest/pgbackrest/archive/refs/tags/release/2.56.0.tar.gz"
  sha256 "e4ed91be1c518817fd2909c99edc0d3661126fde86abf77a0d470da09741447f"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f1727886ba7c055789f170316df6aa3666742180f4099ecbb9ffd587876a0980"
    sha256 cellar: :any, arm64_sequoia: "0a77ba3f63ff7096272d2dfa7e4110aadc35142b7145b836be40d1ab9e73ffa7"
    sha256 cellar: :any, arm64_sonoma:  "12d5430093b5ee98673a1f36698c2c21bd226112d73a973d79a8e096c473a20e"
    sha256 cellar: :any, arm64_ventura: "7e0176bc8b7384ec8a00f971ee82b6947fe48a341616ee8937029fdfee308da6"
    sha256 cellar: :any, sonoma:        "910f8147299975e6832708e18d2060942b7517cb333f94f7cc07d7dfa3542d0c"
    sha256 cellar: :any, ventura:       "7c1309e653236d9042bb77a0851e3d6854cfc64717d30277b5cff4cfe7397ad8"
    sha256               arm64_linux:   "49c83e933c68b8bb8d3a3ec4f78e5618b8b919affc680c5108c6bc75d2bfb0f4"
    sha256               x86_64_linux:  "12c203dadba354600c72fe36b2d1421b0bf7c379a2b2ee4f3e3953abb071a7f3"
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
