class Libebml < Formula
  desc "Sort of a sbinary version of XML"
  homepage "https://www.matroska.org/"
  url "https://dl.matroska.org/downloads/libebml/libebml-1.3.4.tar.bz2"
  mirror "https://www.bunkus.org/videotools/mkvtoolnix/sources/libebml-1.3.4.tar.bz2"
  sha256 "c50d3ecf133742c6549c0669c3873f968e11a365a5ba17b2f4dc339bbe51f387"

  bottle do
    cellar :any
    sha256 "953d50863d804b564e80a60efc0ef8c13b1ad2763d17dfd06131b125039764ad" => :sierra
    sha256 "102b5fa493597b2b3fffbf5b08f3dabf280fe113f180a5261c38457aef922e5b" => :el_capitan
    sha256 "cac2465703dfe3b956e9d7b6cdeda3f61bbca6c31c7acd59fd11d88c1f55dd3d" => :yosemite
    sha256 "645dc73f0462264c280368c1de64119e5b2ff895998dee8dc74d32a94b922581" => :mavericks
  end

  head do
    url "https://github.com/Matroska-Org/libebml.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option :cxx11

  def install
    ENV.cxx11 if build.cxx11?
    system "autoreconf", "-fi" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
