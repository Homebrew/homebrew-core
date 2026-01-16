class Libraw < Formula
  desc "Library for reading RAW files from digital photo cameras"
  homepage "https://www.libraw.org/"
  url "https://www.libraw.org/data/LibRaw-0.21.5.tar.gz"
  sha256 "20ecfa6aad943d383ab3f66d303727ef542b042cbba2bb7ddaeff0bb2e9ff916"
  license any_of: ["LGPL-2.1-only", "CDDL-1.0"]

  livecheck do
    url "https://www.libraw.org/download/"
    regex(/href=.*?LibRaw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "397688a56c416a00d0e7b64853f9c4bf2c292800d1a52f33593b2451bf5ac377"
    sha256 cellar: :any,                 arm64_sequoia: "5fa562a5dcbe5692bf69f802720601d40bbbf869fc27f323b2cc5c18ef32e679"
    sha256 cellar: :any,                 arm64_sonoma:  "03b5fd9502944ff422eb56c308153834aeed5ce3427629d9aba6d7899ba730a4"
    sha256 cellar: :any,                 sonoma:        "a67f33061d0e037b2d508f36f5fbb1640ba162024649456c8010feac2281b38e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d2e5c9e6ce3799fa04a0d47b8e3763b5283d507fd89e03032a969f286fb71e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e628748535cd48b566871ee4007675d4e65ceb3bbeba91d872a777cbe847a81c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "jasper"
  depends_on "jpeg-turbo"
  depends_on "little-cms2"

  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  def install
    args = []
    if OS.mac?
      # Work around "checking for OpenMP flag of C compiler... unknown"
      args += [
        "ac_cv_prog_c_openmp=-Xpreprocessor -fopenmp",
        "ac_cv_prog_cxx_openmp=-Xpreprocessor -fopenmp",
        "LDFLAGS=-lomp",
      ]
    end
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
    doc.install Dir["doc/*"]
    prefix.install "samples"
  end

  test do
    resource "homebrew-librawtestfile" do
      url "https://www.rawsamples.ch/raws/nikon/d1/RAW_NIKON_D1.NEF"
      mirror "https://web.archive.org/web/20200703103724/https://www.rawsamples.ch/raws/nikon/d1/RAW_NIKON_D1.NEF"
      sha256 "7886d8b0e1257897faa7404b98fe1086ee2d95606531b6285aed83a0939b768f"
    end

    resource("homebrew-librawtestfile").stage do
      filename = "RAW_NIKON_D1.NEF"
      system bin/"raw-identify", "-u", filename
      system bin/"simple_dcraw", "-v", "-T", filename
    end
  end
end
