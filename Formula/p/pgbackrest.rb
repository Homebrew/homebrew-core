class Pgbackrest < Formula
  desc "Reliable PostgreSQL Backup & Restore"
  homepage "https://pgbackrest.org"
  url "https://github.com/pgbackrest/pgbackrest/releases/download/release/2.60.1/pgbackrest-2.60.1.tar.gz"
  sha256 "c6d8190fee982f0febdd2ca5ca112f83b4b0905ef9949e9cf64a46a6cc138026"
  license "MIT"

  bottle do
    manifest_sha256 "6a4861e5110300229bad08bef94d60da6fb216f2679d1742e01b891c95eb8aed"
    sha256 cellar: :any, arm64_golden_gate: "8b92f397cd7790c6cb8b2668b016520b3173bda4e948e9e613e781ee6eba9997"
    sha256 cellar: :any, arm64_tahoe:       "53ae6cf09ce9ae96eff19ee71d13e5eea4eab5f8ad2dc6548d52ff0f60b16686"
    sha256 cellar: :any, arm64_sequoia:     "db4ee8f0c0e8fa2dd55da99f5a1a27bbd44d0e98584a4fd24b775a603b0d1ed8"
    sha256 cellar: :any, arm64_linux:       "26e1f269b55dbd08bb276ffd6aaaf2af58de6bc17041f8dd6e26a20afff287ad"
    sha256 cellar: :any, x86_64_linux:      "68e7ca7b3de5320dca8f9cd5f68b910882abc0d6720c784a11baf763cb30d439"
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
