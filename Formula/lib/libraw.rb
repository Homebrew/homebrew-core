class Libraw < Formula
  desc "Library for reading RAW files from digital photo cameras"
  homepage "https://www.libraw.org/"
  url "https://www.libraw.org/data/LibRaw-0.21.4.tar.gz"
  sha256 "6be43f19397e43214ff56aab056bf3ff4925ca14012ce5a1538a172406a09e63"
  license any_of: ["LGPL-2.1-only", "CDDL-1.0"]

  livecheck do
    url "https://www.libraw.org/download/"
    regex(/href=.*?LibRaw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "287cc254f72ccd737e74bdb9f6d08748072d481e319fcb890490bf4271ca5b37"
    sha256 cellar: :any,                 arm64_sequoia: "3ae642e1a337a7183e77b6a3d59fdaf9fa13b56fcd8e565498c494427cc085b3"
    sha256 cellar: :any,                 arm64_sonoma:  "38e57ff44d6cc053438c04e4654d7a7d1e3d3ce401eb02b94162ac5ad33a30ab"
    sha256 cellar: :any,                 arm64_ventura: "91aebf5f2364ad1b770c25d9026f6e8feb380d01de21f871acc63e4d41868b3f"
    sha256 cellar: :any,                 sonoma:        "6ddce452df9c2f67cea7d9e0a55c54d79b1adcebfc63af069531b447493e7576"
    sha256 cellar: :any,                 ventura:       "2e632c46f2d8f9f1789787844d1a7c97fc1d08dd55fed9f7c6ab6c6ecd48a8a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d3619295185f5f2a8f12f3718c1edad97f825504a8c05262de5057aa9a8c3c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69fbec4dfdee24831513339f9315f18bf73ee343190c906ec1eea21fa22ffd0b"
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
