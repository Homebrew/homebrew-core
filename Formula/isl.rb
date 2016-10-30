class Isl < Formula
  desc "Integer Set Library for the polyhedral model"
  homepage "http://isl.gforge.inria.fr"
  # Note: Always use tarball instead of git tag for stable version.
  #
  # Currently isl detects its version using source code directory name
  # and update isl_version() function accordingly.  All other names will
  # result in isl_version() function returning "UNKNOWN" and hence break
  # package detection.
  url "http://isl.gforge.inria.fr/isl-0.17.1.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/i/isl/isl_0.17.1.orig.tar.xz"
  sha256 "be152e5c816b477594f4c6194b5666d8129f3a27702756ae9ff60346a8731647"

  bottle do
    cellar :any
    sha256 "576527b154c7685f3cab34231732b8ad04edf1c10eb86fd5add7ec5fe35ae5b7" => :sierra
    sha256 "906a846dca409b6cd1ae671f010486c48b1a9dc4a19a9d287dcb7db1b64c523d" => :el_capitan
    sha256 "3e7b39a62deef1a50df0affe4af50285a1e22e9aa32eb70c6099b06863d4de29" => :yosemite
    sha256 "aa211db34ef7be89791ccc9057e0742b4a8bad94685be0f33b196ba10a6abef3" => :mavericks
  end

  head do
    url "http://repo.or.cz/r/isl.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gmp"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-gmp=system",
                          "--with-gmp-prefix=#{Formula["gmp"].opt_prefix}"
    system "make", "install"
    (share/"gdb/auto-load").install Dir["#{lib}/*-gdb.py"]
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <isl/ctx.h>

      int main()
      {
        isl_ctx* ctx = isl_ctx_alloc();
        isl_ctx_free(ctx);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lisl", "-o", "test"
    system "./test"
  end
end
