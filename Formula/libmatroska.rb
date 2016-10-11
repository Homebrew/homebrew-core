class Libmatroska < Formula
  desc "Extensible, open standard container format for audio/video"
  homepage "https://www.matroska.org/"
  url "https://dl.matroska.org/downloads/libmatroska/libmatroska-1.4.5.tar.bz2"
  mirror "https://www.bunkus.org/videotools/mkvtoolnix/sources/libmatroska-1.4.5.tar.bz2"
  sha256 "79023fa46901e5562b27d93a9dd168278fa101361d7fd11a35e84e58e11557bc"

  bottle do
    cellar :any
    sha256 "56deeccf102a2f275d19976d6874fb9a9e031af41a485c09137b681f7e9ed048" => :sierra
    sha256 "1f5fae2fa53865b2604565422a8d2a2c05f2a3704f7ff89f1e2edf1a0ea98bff" => :el_capitan
    sha256 "0970585e51b2ce6918660216a1f3f86e097738705b1943c80b2b30e9bc90ca78" => :yosemite
    sha256 "c91f48f96377c6002da12767f4ddbec4cec71001137d378af1eb18f862088544" => :mavericks
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
