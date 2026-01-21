class Libraw < Formula
  desc "Library for reading RAW files from digital photo cameras"
  homepage "https://www.libraw.org/"
  url "https://www.libraw.org/data/LibRaw-0.22.0.tar.gz"
  sha256 "1071e6e8011593c366ffdadc3d3513f57c90202d526e133174945ec1dd53f2a1"
  license any_of: ["LGPL-2.1-only", "CDDL-1.0"]

  livecheck do
    url "https://www.libraw.org/download/"
    regex(/href=.*?LibRaw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dfe8c4adec863a847081a26b920b5578cbe404caf4835e88adc3b7f694482306"
    sha256 cellar: :any,                 arm64_sequoia: "a2f2457cfea6bed531e084dda485cd98846adf1cecd8073dc1a3f74af4815e16"
    sha256 cellar: :any,                 arm64_sonoma:  "6da36c87e5dfea4b1574fbbbdaf2b8a06758f32bfbfba28335df8e7632c79ad4"
    sha256 cellar: :any,                 sonoma:        "a0395da394caae64e9afb26e5db4dec49c05e871ae2535518c4e30affdd2b4ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29194cb559cb434d5152584fc96ecb998cf68b4d5914647e17c43d2ec0cb52a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63c52fa08f036ff2d6b90afb8a24670e19f63e9de821e02cc85c310296257f9b"
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
