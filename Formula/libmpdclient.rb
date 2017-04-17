class Libmpdclient < Formula
  desc "Library for MPD in the C, C++, and Objective-C languages"
  homepage "https://www.musicpd.org/libs/libmpdclient/"
  url "https://www.musicpd.org/download/libmpdclient/2/libmpdclient-2.11.tar.gz"
  sha256 "249d510c96142f14c8c45f5f8f6bd824bfd45f534cc386aa60ca492ab2f98ede"

  bottle do
    cellar :any
    sha256 "ab84b63fdac72459fe7cff11655ef233ae2561aa218177229d40f4848e1c452d" => :sierra
    sha256 "1fa73b275597ded3bbed6a39aadce1dd9af6f77711c4cfd8f3d9a50b31e3662a" => :el_capitan
    sha256 "98202831315d735c430e8b7071f513b4eafb3715bbcf51090db87b451d59d242" => :yosemite
  end

  head do
    url "git://git.musicpd.org/master/libmpdclient.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "doxygen" => :build

  def install
    inreplace "autogen.sh", "libtoolize", "glibtoolize"
    system "./autogen.sh" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
