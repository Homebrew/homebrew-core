class Libraw < Formula
  desc "Library for reading RAW files from digital photo cameras"
  homepage "https://www.libraw.org/"
  url "https://www.libraw.org/data/LibRaw-0.21.1.tar.gz"
  sha256 "630a6bcf5e65d1b1b40cdb8608bdb922316759bfb981c65091fec8682d1543cd"
  license any_of: ["LGPL-2.1-only", "CDDL-1.0"]

  livecheck do
    url "https://www.libraw.org/download/"
    regex(/href=.*?LibRaw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9a3f7961ea91c55afaed1216f5decffa456b3527b17ea26a118bbe325996cfbc"
    sha256 cellar: :any,                 arm64_monterey: "24a8108e336f47fbaf1356831cc6558863a8456ec1245acfd4267375e44af4e1"
    sha256 cellar: :any,                 arm64_big_sur:  "c863d5750f4e4bfc1ddb8559fa9bff096b169b440d3ab40101b8c6fc5f43546d"
    sha256 cellar: :any,                 ventura:        "0ab32829325aafbf2162cde11b7af7ec8f9795b7490942a4a51b16ddb580de6a"
    sha256 cellar: :any,                 monterey:       "7dd1a73ccdddcde857cb3d88e55112b3c249414a85eb8e35dbd9dcf2dbe88360"
    sha256 cellar: :any,                 big_sur:        "c4ead53e27fcacc11576f8e47d2b99d0f1463f526da1cf59a3476e7c12568718"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d801100708c2f9cd47ce4ff6fc624c3ed8fc1ce1c0b72db9b8c9ebed7eaf6a4b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "jasper"
  depends_on "jpeg-turbo"
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
