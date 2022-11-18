class Libraw < Formula
  desc "Library for reading RAW files from digital photo cameras"
  homepage "https://www.libraw.org/"
  url "https://www.libraw.org/data/LibRaw-0.20.2.tar.gz"
  sha256 "dc1b486c2003435733043e4e05273477326e51c3ea554c6864a4eafaff1004a6"
  license any_of: ["LGPL-2.1-only", "CDDL-1.0"]
  revision 3

  livecheck do
    url "https://www.libraw.org/download/"
    regex(/href=.*?LibRaw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e4ab08ff590549de7c1aa488e2e225a74e1186a1b51e71956488dc909a7bd8ee"
    sha256 cellar: :any,                 arm64_monterey: "8fabdbb3e0bea64967859d1566709b7a1eb20100548f8dde61300a0982f3d78c"
    sha256 cellar: :any,                 arm64_big_sur:  "5587bd22619b0f9942337f66054fbf8f3dc943aeb09f258bd1216eea779439e6"
    sha256 cellar: :any,                 ventura:        "3b1f4caf1e17e245871ae31ab827c63bac71938bf5994b4258b54dd765a55d43"
    sha256 cellar: :any,                 monterey:       "7c67db7c1d4da6c580782470bc3b9ca9b2ab310d912bae0d04b0fe1b400da1ff"
    sha256 cellar: :any,                 big_sur:        "49845b546bb0df84878d6a9e9dec4f5ce210c76ce57713f1fe9aa73cb0af56e6"
    sha256 cellar: :any,                 catalina:       "a0207e575f4846216b3e7485d8e384bf3f7f5357adc68fb93537555f859223cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2ad0da2bae19eea705cdfdc0841a5acf80d5a8abb65a72fe1e560059591da2d"
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
