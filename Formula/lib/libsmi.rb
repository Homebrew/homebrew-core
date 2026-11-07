class Libsmi < Formula
  desc "Library to Access SMI MIB Information"
  homepage "https://www.ibr.cs.tu-bs.de/projects/libsmi/"
  # Use mirror here as `https://www.ibr.cs.tu-bs.de/projects/libsmi/download/libsmi-0.5.0.tar.gz`
  # does not have stable checksum (i.e. it changes every time we try to download it)
  url "https://www.mirrorservice.org/sites/distfiles.macports.org/libsmi/libsmi-0.5.0.tar.gz"
  sha256 "f21accdadb1bb328ea3f8a13fc34d715baac6e2db66065898346322c725754d3"
  license all_of: ["TCL", "BSD-3-Clause", "Beerware"]
  compatibility_version 1

  livecheck do
    url "https://www.ibr.cs.tu-bs.de/projects/libsmi/download/"
    regex(/href=.*?libsmi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 3
    sha256 arm64_golden_gate: "faf7c58c617d0c080e8d1c9885fb7e0f75e4d6520fe6dbd573b7b25c51a8ebdb"
    sha256 arm64_tahoe:       "e1082c2409875802d0f39358520e3936b8f02b283203cb6bd50aff0d94fa2511"
    sha256 arm64_sequoia:     "6e30b645bf5eeb0a1b912b806b43210f5946ba59e350650cfa872b5d34baeb1b"
    sha256 arm64_linux:       "6f23251957bd0b79d0fc5cb9c48c033d2949084dc7fd8c62da33c01ab8c2395c"
    sha256 x86_64_linux:      "85a0483f3179a3ad68448425b4b3dd7642cf617c1f1ce22473f5bd69427459b2"
  end

  # Regenerate `configure` to avoid `-flat_namespace` bug.
  # None of our usual patches apply.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  deny_network_access!

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403
    # C23 makes `()` mean `(void)`, breaking the K&R-style parser prototypes
    ENV.append_to_cflags "-std=gnu17"

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/smidiff -V")
  end
end
