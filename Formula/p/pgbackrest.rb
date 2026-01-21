class Pgbackrest < Formula
  desc "Reliable PostgreSQL Backup & Restore"
  homepage "https://pgbackrest.org"
  url "https://github.com/pgbackrest/pgbackrest/archive/refs/tags/release/2.58.0.tar.gz"
  sha256 "2517ec0a7f66be0f1bc77795c3a19cd41c4b106699321d3ac511bc539dd2bfca"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c4dcda0ce80b65f0eb89b01b65597e403d2ea9fef9699f4445627fd27b2fbd55"
    sha256 cellar: :any, arm64_sequoia: "d47591951421f7c9ec4a3a53fa16aaa3addcfebea79aaeea604ba44d53942e26"
    sha256 cellar: :any, arm64_sonoma:  "68704df2bfa7cd6b1e7a14687c7bc4619837e78f252276e0335e57a79fc76a78"
    sha256 cellar: :any, sonoma:        "35a6492cb9596bdf811ccb87412a99962242c525fe61fbc3144a1b35efa8f116"
    sha256               arm64_linux:   "f600113c9ef79f9be687a6de9f56ea183484a657a7a53f82e43f6d8a20f21aa0"
    sha256               x86_64_linux:  "0c05d59f22af465f3b650c6992ddf99a6af622b108eecc5f23587e0717aec91a"
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
