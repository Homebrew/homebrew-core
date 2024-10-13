class Libraw < Formula
  desc "Library for reading RAW files from digital photo cameras"
  homepage "https://www.libraw.org/"
  url "https://www.libraw.org/data/LibRaw-0.21.3.tar.gz"
  sha256 "dba34b7fc1143503942fa32ad9db43e94f714e62a4a856e91617f8f3e1e0aa5c"
  license any_of: ["LGPL-2.1-only", "CDDL-1.0"]

  livecheck do
    url "https://www.libraw.org/download/"
    regex(/href=.*?LibRaw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ba55dd6e2ef79dd0209e014e8daeb551bc570d9e7ac2487d21e3c46560833197"
    sha256 cellar: :any,                 arm64_sonoma:  "31667768485f1282524aabb8d87d67a5a5486474f46ebf39032332d100951270"
    sha256 cellar: :any,                 arm64_ventura: "a838c01a9bbcec7c03e07aef69d05ce9a03c7e9baae6a6548fed400bf50f448d"
    sha256 cellar: :any,                 sonoma:        "90c5c097b1a8434966ebd16fe499dbd8450497eb6f6a387f19dd1481f7d071b9"
    sha256 cellar: :any,                 ventura:       "64318f3bc3cec56cb5ff4e2669fcba4e5fd5a5e49f2c4bb392f3000f8d625cb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d1ddb246412946860765bb57fa3ebb3cfd6d4d1a13be9a1524decb3404e7ff5"
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
