class Pgbackrest < Formula
  desc "Reliable PostgreSQL Backup & Restore"
  homepage "https://pgbackrest.org"
  url "https://github.com/pgbackrest/pgbackrest/archive/refs/tags/release/2.57.0.tar.gz"
  sha256 "d794519c0ecb4ec17f41c4267d07fe80ab6b3ac9cc1de5c7984887c5e6d7448a"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d3cf07a615ec618eb8dbdc3cefa03ce8dd3895d3d6a5557116b7b5e431a48ab6"
    sha256 cellar: :any, arm64_sequoia: "c93d342cd7c58c9029c67c457709ac1782a9caad192599a72acbb067ab1f3a4b"
    sha256 cellar: :any, arm64_sonoma:  "b78cc317d9f2565005350cc20eeb32d8e29a2f355a2a5a97bf632dc04a5a80e8"
    sha256 cellar: :any, sonoma:        "52894f51c68d6dbe4b4672c21eb426064a0b47db92a780a92f8e6e6673ff57d1"
    sha256               arm64_linux:   "d274195e3026a4a3a480e434d1e22172fe191db03be45a695f437c0055e6ee45"
    sha256               x86_64_linux:  "bb4c77567c72f4e9adfa418b0b8d2ca559e68af4bf03494c207994e78138a2e1"
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
