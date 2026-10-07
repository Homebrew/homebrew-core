class Pgbackrest < Formula
  desc "Reliable PostgreSQL Backup & Restore"
  homepage "https://pgbackrest.org"
  url "https://github.com/pgbackrest/pgbackrest/releases/download/release/2.59.3/pgbackrest-2.59.3.tar.gz"
  sha256 "14037901db002e5536a948bf9f0fc0ff6cde31f4e675d3e9b46f129071bf2e5f"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "692cd091842596f79eec1fd8f5837b4e3cd0cc23b128a1b2e9e06f01dd17af03"
    sha256 cellar: :any, arm64_tahoe:       "e8dd2488e26fe2b07fa61b1e803c1835a0906f26536e4032c0b5d406f885e40c"
    sha256 cellar: :any, arm64_sequoia:     "44f0152ba5a76f080f5f5634fc2bf0af9d586a5d9bb7a9a3f266e2de7f9b91bb"
    sha256 cellar: :any, arm64_linux:       "6c04a716d569ab1ed917542331bd75d05a2a9dfa75a673ba025914e8c4211ec3"
    sha256 cellar: :any, x86_64_linux:      "fc4bb5581d13a4bf17bda5b3f9ab43449963f17b2017b46c77f98239b7bb9aaa"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libpq"
  depends_on "libssh2"
  depends_on "lz4"
  depends_on "openssl@4"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath(target: formula_opt_lib("libpq"))}" if OS.linux?

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    output = shell_output("#{bin}/pgbackrest info")
    assert_match "No stanzas exist in the repository.", output
  end
end
