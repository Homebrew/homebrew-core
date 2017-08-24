class Btfs < Formula
  desc "BitTorrent filesystem based on FUSE"
  homepage "https://github.com/johang/btfs"
  url "https://github.com/johang/btfs/archive/v2.16.tar.gz"
  sha256 "673013ba648285f380848ae2e2f8a06800f781a0680582c0d550cc0c563cc08b"
  head "https://github.com/johang/btfs.git"

  bottle do
    cellar :any
    sha256 "f8cefaa7ac9831c5277f01c0db1b0614d9d7a4f8356cf70cfa99e0fa84af03ca" => :sierra
    sha256 "30053d94f609415889dfc10a673cef5c3a96d491a5aae6c8a2875c5fc09b55d6" => :el_capitan
    sha256 "bb8df8924b3aa2b302aadff26cbf9ab9cc2c762ac2f92481458efa82658f32ad" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on :osxfuse
  depends_on "libtorrent-rasterbar"

  def install
    ENV.cxx11
    inreplace "configure.ac", "fuse >= 2.8.0", "fuse >= 2.7.3"
    system "autoreconf", "--force", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/btfs", "--help"
  end
end
