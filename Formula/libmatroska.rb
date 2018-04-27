class Libmatroska < Formula
  desc "Extensible, open standard container format for audio/video"
  homepage "https://www.matroska.org/"
  url "https://dl.matroska.org/downloads/libmatroska/libmatroska-1.4.8.tar.xz"
  sha256 "d8c72b20d4c5bf888776884b0854f95e74139b5267494fae1f395f7212d7c992"
  revision 1

  bottle do
    cellar :any
    sha256 "1f892100068d00d8a6d8d8026c09c155bd4f988d19d61380f1ba88426c72fdb7" => :high_sierra
    sha256 "4930a15c41e6be209554d3015b4d8b27fe6fad3b96a6b91e3686c9650ba55d6c" => :sierra
    sha256 "60c6aea336b9d18883da2bdccbd1979836e0803232f57c688806c5886969912c" => :el_capitan
  end

  head do
    url "https://github.com/Matroska-Org/libmatroska.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libebml"

  def install
    system "autoreconf", "-fi" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
