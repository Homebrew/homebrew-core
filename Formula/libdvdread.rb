class Libdvdread < Formula
  desc "C library for reading DVD-video images"
  homepage "https://www.videolan.org/developers/libdvdnav.html"
  url "https://download.videolan.org/pub/videolan/libdvdread/6.1.1/libdvdread-6.1.1.tar.bz2"
  sha256 "3e357309a17c5be3731385b9eabda6b7e3fa010f46022a06f104553bf8e21796"

  bottle do
    cellar :any
    sha256 "8d8dba7bee50281bae15eaab753b224c1a75aaa4b45b5b89f41c366ef64296d0" => :catalina
    sha256 "1e1bf0699caa152d44c3006d9b4531cb22b04fa126d4d9a8fa41ca5f58245619" => :mojave
    sha256 "2447aa683f9a8c28266e1aab68f1b3e354a9f8a6a17e4709aa68208e3762cc64" => :high_sierra
  end

  head do
    url "https://code.videolan.org/videolan/libdvdread.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "libdvdcss"

  def install
    ENV.append "CFLAGS", "-DHAVE_DVDCSS_DVDCSS_H"
    ENV.append "LDFLAGS", "-ldvdcss"

    system "autoreconf", "-if" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
