class Libmpeg2 < Formula
  desc "Library to decode mpeg-2 and mpeg-1 video streams"
  homepage "https://libmpeg2.sourceforge.io/"
  url "https://libmpeg2.sourceforge.io/files/libmpeg2-0.5.1.tar.gz"
  sha256 "dee22e893cb5fc2b2b6ebd60b88478ab8556cb3b93f9a0d7ce8f3b61851871d4"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://libmpeg2.sourceforge.io/downloads.html"
    regex(/href=.*?libmpeg2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a5522ab17783c821344f34583781d561c6c579ab60c28483fb934e66fddfc93f"
    sha256 cellar: :any,                 arm64_monterey: "aa96e119c487436a7b9e36820137e17fa84007f174c8476e70f74d6a41972036"
    sha256 cellar: :any,                 arm64_big_sur:  "53f205eb140836cb0593cb34318a62a9381d950fcdf7c949e861e1024dbf352f"
    sha256 cellar: :any,                 ventura:        "013738fd28fb6f8a52d1a9346c24cee9b4a2e09e0260c3b4f9917146a49de3fa"
    sha256 cellar: :any,                 monterey:       "fb3ad194c995a22c85768c3032a0d04b195a2e3b4684b1256f6498581d87bc5a"
    sha256 cellar: :any,                 big_sur:        "81fede3e5bf51daaed591f1eab2ecb777b092f5c99386b2a751618b059c7d2f1"
    sha256 cellar: :any,                 catalina:       "c25d746458652a4e7f87e67478b1451924da48a82d98a8eae83e36cceb336428"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04a7bbf5129d11b695a6a57eff6091f6519e3b4554dc77f84bca351a4f17acaa"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "sdl12-compat"

  def install
    # Otherwise compilation fails in clang with `duplicate symbol ___sputc`
    ENV.append_to_cflags "-std=gnu89"

    system "autoreconf", "-fiv"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "doc/sample1.c"
  end

  test do
    system ENV.cc, "-I#{include}/mpeg2dec", pkgshare/"sample1.c", "-L#{lib}", "-lmpeg2"
  end
end
