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
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "5063da59ac2ac5cf2b4d25980ae221d368595521c1b86899235459edb1b5984d"
    sha256 cellar: :any,                 arm64_ventura:  "41c00d2aeda3ff3685e668e4663a02e4a7323a39889ff03f4189a3c4f8d4e3bf"
    sha256 cellar: :any,                 arm64_monterey: "fb2ffa13a08011a3ff0ae37b6eeb545cdefee863c95379cd2bf3d2be5c9f6241"
    sha256 cellar: :any,                 sonoma:         "e677a3136c2850ad5ada21e3832c68d790efc4b5d26bc1334eb0ac0839a18cba"
    sha256 cellar: :any,                 ventura:        "f84f64f453a6442c5fce906386f4276666ab3717e6d52deddd10f80880b6dcee"
    sha256 cellar: :any,                 monterey:       "833084fac47f3aae49d8177d56c0e98551b1e24382567bb1fc6111df1b7fcf67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dd8870ae5ebbaf3e4a7b4a70a0d1c2ca96dd91f5542e449e04e058d7d62b184"
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
      sha256 "7886d8b0e1257897faa7404b98fe1086ee2d95606531b6285aed83a0939b768f"
    end

    resource("homebrew-librawtestfile").stage do
      filename = "RAW_NIKON_D1.NEF"
      system bin/"raw-identify", "-u", filename
      system bin/"simple_dcraw", "-v", "-T", filename
    end
  end
end
