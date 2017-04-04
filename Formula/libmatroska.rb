class Libmatroska < Formula
  desc "Extensible, open standard container format for audio/video"
  homepage "https://www.matroska.org/"
  url "https://dl.matroska.org/downloads/libmatroska/libmatroska-1.4.7.tar.bz2"
  sha256 "46441eb3bae9f970f68affaa211dd74302a7072dcd2becfb1114da11b66525fa"

  bottle do
    cellar :any
    sha256 "398600a9d263811da4423a5e8eb0a491ab2605b95285bc6ce6618c513d015ad8" => :sierra
    sha256 "7ac90bec5f13fe0d9a92d23c3213c71c9eadabb37f924f105b4fb7fccb8acc2b" => :el_capitan
    sha256 "1df5606ade757f979069962524de4442fd1a353179373af334fba5a92f6142d7" => :yosemite
  end

  head do
    url "https://github.com/Matroska-Org/libmatroska.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option :cxx11

  if build.cxx11?
    depends_on "libebml" => "c++11"
  else
    depends_on "libebml"
  end

  depends_on "pkg-config" => :build

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
