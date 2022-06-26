class Libraw < Formula
  desc "Library for reading RAW files from digital photo cameras"
  homepage "https://www.libraw.org/"
  url "https://www.libraw.org/data/LibRaw-0.20.2.tar.gz"
  sha256 "dc1b486c2003435733043e4e05273477326e51c3ea554c6864a4eafaff1004a6"
  license any_of: ["LGPL-2.1-only", "CDDL-1.0"]
  revision 2

  livecheck do
    url "https://www.libraw.org/download/"
    regex(/href=.*?LibRaw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "18c36994429964daaa9946aa3850f94f9fd6ba7c75692d81f2a5de422c7d2f1e"
    sha256 cellar: :any,                 arm64_big_sur:  "edce6b5fa1e302705761e0d9b851422a04a98fa9e4acfa855544d13ecfa18565"
    sha256 cellar: :any,                 monterey:       "e5e88f0e87405beceb2f0e0dcb7f7f0621f43173cf93a4d0e543a94688daf062"
    sha256 cellar: :any,                 big_sur:        "6e1dc8ff8d4a11db7aab2dad4a310050b50dceb853f0fb5a8f49644f748dc2d9"
    sha256 cellar: :any,                 catalina:       "bed8bf5d99ea03bd19b8fe962824518d1ce5b1b1cc7292decad833556b7079c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bb0248790c8d19f90e486b5ffefe19499f443523a484ca74745a72efe5e16d6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "jasper"
  depends_on "jpeg"
  depends_on "little-cms2"

  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  resource "homebrew-librawtestfile" do
    url "https://www.rawsamples.ch/raws/nikon/d1/RAW_NIKON_D1.NEF"
    sha256 "7886d8b0e1257897faa7404b98fe1086ee2d95606531b6285aed83a0939b768f"
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
    system "./configure", *std_configure_args, *args
    system "make"
    system "make", "install"
    doc.install Dir["doc/*"]
    prefix.install "samples"
  end

  test do
    resource("homebrew-librawtestfile").stage do
      filename = "RAW_NIKON_D1.NEF"
      system "#{bin}/raw-identify", "-u", filename
      system "#{bin}/simple_dcraw", "-v", "-T", filename
    end
  end
end
