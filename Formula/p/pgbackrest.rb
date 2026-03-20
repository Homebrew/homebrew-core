class Pgbackrest < Formula
  desc "Reliable PostgreSQL Backup & Restore"
  homepage "https://pgbackrest.org"
  url "https://github.com/pgbackrest/pgbackrest/archive/refs/tags/release/2.58.0.tar.gz"
  sha256 "2517ec0a7f66be0f1bc77795c3a19cd41c4b106699321d3ac511bc539dd2bfca"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "ddf0b1c7f851c41a77323611559129b573d908defcf89c0ce441c43d742d02a1"
    sha256 cellar: :any, arm64_sequoia: "1e88c3515ef3cef29cc6f5b54d36553ea31162934558f664540f87e208fd41d3"
    sha256 cellar: :any, arm64_sonoma:  "444bfaf0fbdab8e7a838ac28df2b141d28e50d2edca914655f2ac1a79a210dd8"
    sha256 cellar: :any, sonoma:        "ab091b268bf5912d2d75eac9110303543d9d3e1a21fa30632bd38da38d3b4869"
    sha256               arm64_linux:   "f94aa5e2ba0c8a37044fc749817bd8bdfa64c37095aee594c758aca26197c681"
    sha256               x86_64_linux:  "aa984f5a9161767d92ea237ce5a55b01342b93c879da811baaba149ab3e0cabb"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
