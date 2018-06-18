class Libewf < Formula
  desc "Library for support of the Expert Witness Compression Format"
  homepage "https://github.com/libyal/libewf"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/libe/libewf/libewf_20140608.orig.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/libe/libewf/libewf_20140608.orig.tar.gz"
  version "20140608"
  sha256 "d14030ce6122727935fbd676d0876808da1e112721f3cb108564a4d9bf73da71"
  revision 2

  bottle do
    cellar :any
    sha256 "10efe12416e50457d968107669bfd2b1bb6e79865301950eb4335ffd6ed43c59" => :high_sierra
    sha256 "c77f644a80bf109f62a9b410917954a79e03ed47fff73b3d0da4f25de6afdf95" => :sierra
    sha256 "5a9c6ce83af6069f84aaf30a5a6ae42eff2e98078835af1c06555852c696b5b4" => :el_capitan
  end

  devel do
    url "https://github.com/libyal/libewf/releases/download/20170703/libewf-experimental-20170703.tar.gz"
    sha256 "84fe12389abacf63dea2d921b636220bb7fda3262d1c467f6d445a5e31f53ade"
  end

  head do
    url "https://github.com/libyal/libewf.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on :osxfuse => :optional

  def install
    if build.head?
      system "./synclibs.sh"
      system "./autogen.sh"
    end

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    args << "--with-libfuse=no" if build.without? "osxfuse"

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ewfinfo -V")
  end
end
