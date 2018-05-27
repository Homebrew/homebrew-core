class Log4cplus < Formula
  desc "Logging Framework for C++"
  homepage "https://sourceforge.net/p/log4cplus/wiki/Home/"
  url "https://downloads.sourceforge.net/project/log4cplus/log4cplus-stable/2.0.1/log4cplus-2.0.1.tar.xz"
  sha256 "813580059fd91260376e411b3e09c740aa86dedc5f6a0bd975b9b39d5c4370e6"

  bottle do
    cellar :any
    sha256 "eacdee3aa723c125f98c7c5d548b918711dcdbc495694607e72b3b497310f3c1" => :high_sierra
    sha256 "4508ad12bb420fbfc24554c874a2d232353984aeba4c44f107f0173e54bbc0ec" => :sierra
    sha256 "91cf1b0b9bd6daae6bd30c26ae7eeecc589e0ca236c07076737de1e41285ade9" => :el_capitan
  end

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
