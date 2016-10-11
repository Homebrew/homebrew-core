class Lrdf < Formula
  desc "RDF library for accessing plugin metadata in the LADSPA plugin system"
  homepage "https://github.com/swh/LRDF"
  url "https://github.com/swh/LRDF/archive/0.5.0.tar.gz"
  sha256 "ba803af936fd53a8b31651043732e6d6cec3d24fa24d2cb8c1506c2d1675e2a2"
  revision 1

  bottle do
    cellar :any
    sha256 "5047c53f45fa906f4f02c5d2f2df8d76aead9299daebe6ba0f1cea516fc5790d" => :sierra
    sha256 "fd014675fccf54f3786877fbff3f3905b44b69cf61b5da3bcba3957c138683be" => :el_capitan
    sha256 "cfb4b27e2dcf30a7c6d81bef96b750339d044de3c31961d1af80634ee8943014" => :yosemite
    sha256 "e3ef1224928a2a5d00753bbc85263acc1208aa6f31ea6750f518f57176836cbf" => :mavericks
    sha256 "31f0395487e70ca4a1f615d5f8ebe3f287faaed7edffca372396b60da2ab4720" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "raptor"
  depends_on "openssl"

  def install
    system "glibtoolize"
    system "aclocal", "-I", "m4"
    system "autoconf"
    system "automake", "-a", "-c"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
