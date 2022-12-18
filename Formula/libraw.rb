class Libraw < Formula
  desc "Library for reading RAW files from digital photo cameras"
  homepage "https://www.libraw.org/"
  url "https://www.libraw.org/data/LibRaw-0.21.0.tar.gz"
  sha256 "8747b34e8534cc2dd7ef8c92c436414b3578904fd4bf9b87ea60f17aa99fb0bd"
  license any_of: ["LGPL-2.1-only", "CDDL-1.0"]

  livecheck do
    url "https://www.libraw.org/download/"
    regex(/href=.*?LibRaw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8b4256545b2414b6aaad493155d810adb1d393b25df0169f12e95c156957e915"
    sha256 cellar: :any,                 arm64_monterey: "d013f4cee6561de346ee4e327f9362bf9d260ba99db77e85406b93a8cfec0858"
    sha256 cellar: :any,                 arm64_big_sur:  "8adb515b95e5497c82372c7b9b30d721e397e5667a94ab18371722d5650d4a36"
    sha256 cellar: :any,                 ventura:        "eea5b7c0f6ab30bc90cb4c77ff63f37ec0cb5777fbe7587bf1a00b365c155854"
    sha256 cellar: :any,                 monterey:       "5da67713d8abe8bc6ddeab64c92438dcda76b2c80493f36d7cf7283c8e4dc800"
    sha256 cellar: :any,                 big_sur:        "518cd6c21dc988a821963dde1b871fe5fe3223664ed0c906d324430bc1289b0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f84a11ebca75c0a2be9b7fc2fe9c53d083fc354fc2d24e24bcb9891cce34bf1"
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
