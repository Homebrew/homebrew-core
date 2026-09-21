class Libsmi < Formula
  desc "Library to Access SMI MIB Information"
  homepage "https://www.ibr.cs.tu-bs.de/projects/libsmi/"
  url "https://www.ibr.cs.tu-bs.de/projects/libsmi/download/libsmi-0.5.0.tar.gz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/libsmi/libsmi-0.5.0.tar.gz"
  sha256 "f21accdadb1bb328ea3f8a13fc34d715baac6e2db66065898346322c725754d3"
  license all_of: ["TCL", "BSD-3-Clause", "Beerware"]

  livecheck do
    url "https://www.ibr.cs.tu-bs.de/projects/libsmi/download/"
    regex(/href=.*?libsmi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 arm64_golden_gate: "690948d97622525d0fd5813d94833dad6ac033ea1c0f35766405a27f153349e3"
    sha256 arm64_tahoe:       "e62990226d7a5b1f0ba50bf081cd6f64e202ce15fdddf6d1970b9a9ffee94409"
    sha256 arm64_sequoia:     "21d96c0231bfce642f8a47cc6f68b8bb5637ee7281ae6daeb27f27044cb54d80"
    sha256 arm64_linux:       "63e66089a6730d1d7d884c67640f0dc0ef73d42b709cd26b4ebe8537ceebed49"
    sha256 x86_64_linux:      "cce9365c53b0e26a272b9d6bed01f481a7851abdc1f066338892e0d2d7a231cf"
  end

  # Regenerate `configure` to avoid `-flat_namespace` bug.
  # None of our usual patches apply.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

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
