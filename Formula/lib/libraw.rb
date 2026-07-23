class Libraw < Formula
  desc "Library for reading RAW files from digital photo cameras"
  homepage "https://www.libraw.org/"
  url "https://www.libraw.org/data/LibRaw-0.22.2.tar.gz"
  sha256 "de86b035655accff8d4010f1a221fdf50d353cb7b1422ba26f14a0db92612cfa"
  license any_of: ["LGPL-2.1-only", "CDDL-1.0"]
  compatibility_version 2

  livecheck do
    url "https://www.libraw.org/download/"
    regex(/href=.*?LibRaw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1954d876dea5007a105c9b72a44c0db378a653879ee19d055e550345171b57a9"
    sha256 cellar: :any, arm64_sequoia: "4b48386f601bb9918ea42f453fc3b666ef05f573c8a50d1b4780c8578c374658"
    sha256 cellar: :any, arm64_sonoma:  "2652cda9de7786db17eab618fd990204d8c3a4c76d0f6a7ddc3c1a438cba84d3"
    sha256 cellar: :any, sonoma:        "a36ddd43c98af6131a823ab3e07a6325406e421b918228d60c42f184d1015347"
    sha256 cellar: :any, arm64_linux:   "5fb8138d4b81b873f49d8815859f4fa0daab90983aa0aa60a2d3d9383f7d15b2"
    sha256 cellar: :any, x86_64_linux:  "e4d86d6478134315d8baf92b5f62cd66a7678acc0aa4679e09b24ac1b122bbb5"
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
