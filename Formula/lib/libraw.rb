class Libraw < Formula
  desc "Library for reading RAW files from digital photo cameras"
  homepage "https://www.libraw.org/"
  url "https://www.libraw.org/data/LibRaw-0.21.2.tar.gz"
  sha256 "fe7288013206854baf6e4417d0fb63ba4ed7227bf36fff021992671c2dd34b03"
  license any_of: ["LGPL-2.1-only", "CDDL-1.0"]

  livecheck do
    url "https://www.libraw.org/download/"
    regex(/href=.*?LibRaw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "75031ae51bb608630a629b5c8a3664d8198eb1a86de6e9deace9ea1ec63f889e"
    sha256 cellar: :any,                 arm64_ventura:  "54931d02c30c96db73386108eca219ce314f57423700ca3107aaac08b3daebfc"
    sha256 cellar: :any,                 arm64_monterey: "0047f8b736b634e6d6b08358ba6fb8acfd9453c2cc35263bb37c901b8e5a5d2b"
    sha256 cellar: :any,                 sonoma:         "b560a97e92ec19e74813e167d2390e60a2fe583206119fed6ce042d2013327fd"
    sha256 cellar: :any,                 ventura:        "81b40bc80c4a7fc6992a24655fb32bc46dc0e1f75f885b66322d4e1785fe18c6"
    sha256 cellar: :any,                 monterey:       "4667607ca30791820c698ed37ce6cd59bc66e0139b747bf9b6839ecd38475376"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2774a6d9383caf3229ed4ac3465c40d35147075c1ae223a03d4e4aa303c1f8a"
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
