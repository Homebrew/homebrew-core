class Libraw < Formula
  desc "Library for reading RAW files from digital photo cameras"
  homepage "https://www.libraw.org/"
  url "https://www.libraw.org/data/LibRaw-0.22.3.tar.gz"
  sha256 "789f3c33466210a1a0907f747a97c715d21bbf4af712f257fcbbd90111b227e4"
  license any_of: ["LGPL-2.1-only", "CDDL-1.0"]
  compatibility_version 2

  livecheck do
    url "https://www.libraw.org/download/"
    regex(/href=.*?LibRaw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3e328426ade77de1722d25c7649c4658556bfa4059da951cb37cbc1ca2626ca3"
    sha256 cellar: :any, arm64_tahoe:       "d1eb97ac93caeff19b655788fc2e57762f80e869ce30b5e0ff15fc787b42ed75"
    sha256 cellar: :any, arm64_sequoia:     "5c38386ead9d07465b4855a5cf06883460d9f4528b14a22813b9cd98277cab26"
    sha256 cellar: :any, arm64_linux:       "e736dd3937afbf8c5f9a40ec5f0336ffbc9092859f415073f5930511eeaaae58"
    sha256 cellar: :any, x86_64_linux:      "9e4e2b9d488641d187fa131a928be510ea032172695f9494a075f8f0692d6da7"
  end

  head do
    url "https://github.com/LibRaw/LibRaw.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "jpeg-turbo"
  depends_on "little-cms2"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "homebrew-librawtestfile", :test do
    url "https://www.rawsamples.ch/raws/nikon/d1/RAW_NIKON_D1.NEF"
    mirror "https://web.archive.org/web/20200703103724/https://www.rawsamples.ch/raws/nikon/d1/RAW_NIKON_D1.NEF"
    sha256 "7886d8b0e1257897faa7404b98fe1086ee2d95606531b6285aed83a0939b768f"
  end

  deny_network_access!

  def install
    # Work around "checking for OpenMP flag of C compiler... unknown".
    # Using -dead_strip_dylibs so `brew linkage` can show if OpenMP is actually used.
    ENV.append "LDFLAGS", "-lomp -Wl,-dead_strip_dylibs" if OS.mac?

    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
    doc.install Dir["doc/*"]
    prefix.install "samples"
  end

  test do
    resource("homebrew-librawtestfile").stage(testpath)
    filename = "RAW_NIKON_D1.NEF"
    system bin/"raw-identify", "-u", filename
    system bin/"simple_dcraw", "-v", "-T", filename
  end
end
