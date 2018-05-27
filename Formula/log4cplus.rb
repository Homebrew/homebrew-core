class Log4cplus < Formula
  desc "Logging Framework for C++"
  homepage "https://sourceforge.net/p/log4cplus/wiki/Home/"
  url "https://downloads.sourceforge.net/project/log4cplus/log4cplus-stable/2.0.1/log4cplus-2.0.1.tar.xz"
  sha256 "813580059fd91260376e411b3e09c740aa86dedc5f6a0bd975b9b39d5c4370e6"

  bottle do
    cellar :any
    sha256 "8f5d5c964260d3d1ce5bd96b2fcd292f12816a20f68c99f27d3790511ff65ff9" => :high_sierra
    sha256 "a47e18c9074c81f9583c25141b44e5b52ab9b18f85b0610b40207a081bfaca68" => :sierra
    sha256 "1ba3ad171f57d728ce82b4dfea6e11cac08f8edd8b77c3bfde2658a63cb0c5d6" => :el_capitan
  end

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
