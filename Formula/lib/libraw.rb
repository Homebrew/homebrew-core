class Libraw < Formula
  desc "Library for reading RAW files from digital photo cameras"
  homepage "https://www.libraw.org/"
  url "https://www.libraw.org/data/LibRaw-0.22.1.tar.gz"
  sha256 "a789dc4e2409e2901d93793a4e0b80c7b49d0d97cf6ad71c850eb7616acfd786"
  license any_of: ["LGPL-2.1-only", "CDDL-1.0"]
  compatibility_version 2

  livecheck do
    url "https://www.libraw.org/download/"
    regex(/href=.*?LibRaw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6d5b21dc4697e4d359934c6d386fa2807319b1cc119e0c74ed47a4226acb9877"
    sha256 cellar: :any,                 arm64_sequoia: "bae39130d2cb53d6b7fd5f4ee48e3412b5ec27ddcf0d8786a37490ed9f655a2b"
    sha256 cellar: :any,                 arm64_sonoma:  "3a1c3da28c276df566c71e5646eabb2cc9797f49cd5e66c744217efa1ce3b55a"
    sha256 cellar: :any,                 sonoma:        "352953a6564709b14b2de0d435bda8de13988b9fd35d0740018d451ae5afa4f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c17f5029564905fa71590b18366243fa2b31b5ee8c2b36cf64bf2d475abac39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d93c19ae3ffdd3ab5b5bde74661e427b81ea0d2c7070669ff0a4409e132ac55b"
  end

  head do
    url "https://github.com/LibRaw/LibRaw.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "jpeg-turbo"
  depends_on "little-cms2"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Work around "checking for OpenMP flag of C compiler... unknown".
    # Using -dead_strip_dylibs so `brew linkage` can show if OpenMP is actually used.
    ENV.append "LDFLAGS", "-lomp -Wl,-dead_strip_dylibs" if OS.mac?

    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args
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

    resource("homebrew-librawtestfile").stage(testpath)
    filename = "RAW_NIKON_D1.NEF"
    system bin/"raw-identify", "-u", filename
    system bin/"simple_dcraw", "-v", "-T", filename
  end
end
