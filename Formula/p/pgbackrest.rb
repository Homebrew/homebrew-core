class Pgbackrest < Formula
  desc "Reliable PostgreSQL Backup & Restore"
  homepage "https://pgbackrest.org"
  url "https://github.com/pgbackrest/pgbackrest/releases/download/release/2.59.3/pgbackrest-2.59.3.tar.gz"
  sha256 "14037901db002e5536a948bf9f0fc0ff6cde31f4e675d3e9b46f129071bf2e5f"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c9294ab2876ec2f905bc623cc56038ccf8f33cd3dd56cad0bfecdbf98f29bfdc"
    sha256 cellar: :any, arm64_tahoe:       "dd9da8be4dd10a9f9fe24186e620fc1c50be46174f4c076a7b6457a39e614ff2"
    sha256 cellar: :any, arm64_sequoia:     "e253dd5b91c6820fc3bbf3e8cd46f1c206a15c67d4c8aadb542334c70ac2a6f3"
    sha256 cellar: :any, arm64_linux:       "12dcfe6c173c1eb866def53e5178ced58a4f0463253eb0c2c183edce47da2d98"
    sha256 cellar: :any, x86_64_linux:      "5e0487cd496dc53f1e6ed415fe48aadbdef5e5f5a7922a0286224c3c2e7d2b58"
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
