class Pgbackrest < Formula
  desc "Reliable PostgreSQL Backup & Restore"
  homepage "https://pgbackrest.org"
  url "https://github.com/pgbackrest/pgbackrest/archive/refs/tags/release/2.55.0.tar.gz"
  sha256 "5172d178a8dff5982ee052c1d45f14e12e8b75dffe3c058ddc8aeb12a5cdd494"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "3b9725234d2aa819c59974aa82911d9635476af39af964bc9b6544903aeb329f"
    sha256 cellar: :any, arm64_sonoma:  "7dc00d937f84739df8e7ae93127e7a4d6a35616eee9a7a50de04b1d248d52e7e"
    sha256 cellar: :any, arm64_ventura: "593d9b67f482c803a0b3f2bc2ae923f95bfd1f115b9860fa1e484b2e73292b40"
    sha256 cellar: :any, sonoma:        "2f47b020f44b70d43027c5a34181aaa25c8624556f553bdba322c1630bdbb574"
    sha256 cellar: :any, ventura:       "aeefd85aeb21c50ddb88354950d95270238aabc3f31534f61132d3a57d260ce5"
    sha256               arm64_linux:   "fd51b718264169fe67f54f4a88348de2752ef92f2b7f7558343902185e58ca49"
    sha256               x86_64_linux:  "5888650b087b1ce122391c5b8e5678fe4b596694840961fb9f328f7a84ff20a5"
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
