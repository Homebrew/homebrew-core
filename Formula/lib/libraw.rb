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
    sha256 cellar: :any,                 arm64_ventura:  "48c6d89fba370facdc7e567846749076f986a42e2da1213185b810d5af6e10c6"
    sha256 cellar: :any,                 arm64_monterey: "14b96b95c16c358c1dde93a035e1f731aa72ad0000875005d239647464496a09"
    sha256 cellar: :any,                 arm64_big_sur:  "81a83bd632b57ca84ce11f0829942a8061c7a57d3568e6c20c54c919fa2c6111"
    sha256 cellar: :any,                 ventura:        "bc0c3676076fd70ee07bba4da886eb70a97539f597d438c785f2cf58af93ec72"
    sha256 cellar: :any,                 monterey:       "33ddfdcf0fbd8d9d0c6bf2408d20b9fd090788ddd2d45bc760d9b78d11b784fa"
    sha256 cellar: :any,                 big_sur:        "4e3c0f783afeac2b9da275168846a87621d95663e592c3225869b1412b155137"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0cae61daa96f85eb9e030c78ce9f023cbf6663f5016a0a793cea445a26d0c31"
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
