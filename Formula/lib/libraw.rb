class Libraw < Formula
  desc "Library for reading RAW files from digital photo cameras"
  homepage "https://www.libraw.org/"
  url "https://www.libraw.org/data/LibRaw-0.22.0.tar.gz"
  sha256 "1071e6e8011593c366ffdadc3d3513f57c90202d526e133174945ec1dd53f2a1"
  license any_of: ["LGPL-2.1-only", "CDDL-1.0"]
  revision 1

  livecheck do
    url "https://www.libraw.org/download/"
    regex(/href=.*?LibRaw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "84d64ea419852d30e62b845b818bf7787cdea94a320963e3c5b2aef4343cc9fd"
    sha256 cellar: :any,                 arm64_sequoia: "103ad865d34ea2ff122569821813fbacd03684c3b5dc20554fd2e49ea28b665a"
    sha256 cellar: :any,                 arm64_sonoma:  "8e96444be4032ee949444f0d67b874a22dfbb886ce68ddb9cfb5f06f576fb8ac"
    sha256 cellar: :any,                 sonoma:        "9bb269ce1bd8563a0ca1941a1d40bb267e4870823ad086d3fb4fc066295c03ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9287051f314cfdc92f385016fb6b234054b62ceaaa96d4eff9ad00d2ce08fc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e670484b1d2a43f0a67e54418f3bfbe0cc152b9940d6a6fa118820a54d6cb472"
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
