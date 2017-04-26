class Blitz < Formula
  desc "C++ class library for scientific computing"
  homepage "https://blitz.sourceforge.io"
  url "https://downloads.sourceforge.net/project/blitz/blitz/Blitz++%200.10/blitz-0.10.tar.gz"
  sha256 "804ef0e6911d43642a2ea1894e47c6007e4c185c866a7d68bad1e4c8ac4e6f94"

  bottle do
    cellar :any
    sha256 "93ec8092122febb4110ce1da374ee5272c6270b7e83fe5da29da4e7f1f1fea6f" => :sierra
    sha256 "dda71ed3f79b926b50f988a931794674908884a411c19b2899ab2a0996a8b71a" => :el_capitan
    sha256 "eabd24b7c07c2f99b181770faacd72bab5c55149fb3d9fb846b2baaaa4faede5" => :yosemite
    sha256 "4baf2939ff5cbe7e0e83944ed8984da49573eafedf826761b4c4fecd954e2592" => :mavericks
  end

  head do
    url "https://github.com/blitzpp/blitz.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "-fi" if build.head?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--infodir=#{info}",
                          "--enable-shared",
                          "--disable-doxygen",
                          "--disable-dot",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
