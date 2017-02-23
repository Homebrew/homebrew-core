class Cheops < Formula
  desc "CHEss OPponent Simulator"
  homepage "https://logological.org/cheops"
  url "https://files.nothingisreal.com/software/cheops/cheops-1.3.tar.bz2"
  mirror "https://github.com/logological/cheops/releases/download/1.3/cheops-1.3.tar.bz2"
  sha256 "a3ce2e94f73068159827a1ec93703b5075c7edfdf5b0c1aba4d71b3e43fe984e"

  bottle do
    cellar :any_skip_relocation
    sha256 "27d8ebc44571902b64043fdcc5c956f89df988e9311ad76eea6f66e2127d3898" => :sierra
    sha256 "aa996a9d23fb57b16bd744aef3746f76d3d3c0316f37ecd258b62d9a36a8b751" => :el_capitan
    sha256 "17d4673487be785e81e1a7cac0a9a3f371cd79cf870906c65d8bdb81fb1a5cc7" => :yosemite
  end

  head do
    url "https://github.com/logological/cheops.git"

    option "with-tex", "Build pdf manual"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on :tex => [:build, :optional]
  end

  def install
    if build.head?
      if build.without? "tex"
        inreplace "Makefile.am",
          "doc_DATA = COPYING NEWS AUTHORS THANKS README doc/cheops.pdf",
          "doc_DATA = COPYING NEWS AUTHORS THANKS README"
      end

      system "autoreconf", "-fiv"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/cheops", "--version"
  end
end
