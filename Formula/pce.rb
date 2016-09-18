class Pce < Formula
  desc "PC emulator"
  homepage "http://www.hampa.ch/pce/"
  url "http://www.hampa.ch/pub/pce/pce-0.2.2.tar.gz"
  sha256 "a8c0560fcbf0cc154c8f5012186f3d3952afdbd144b419124c09a56f9baab999"
  revision 1

  head "git://git.hampa.ch/pce.git"

  bottle do
    cellar :any
    sha256 "bbb6b750a67ee7f0aa91feaeb8a94412effeba42b1ee2a63cfbb9d1c2e7bcfb9" => :el_capitan
    sha256 "30cb9e41b4f37a9880294c7f0622a293982e373d394d75b2c84b3c60f8c4c253" => :yosemite
    sha256 "0771aecfb195d126f71e23af2ba77779dbfef3ff93c9149934f41e41b074d310" => :mavericks
  end

  devel do
    url "http://www.hampa.ch/pub/pce/pre/pce-20160308-72f1e10.tar.gz"
    version "20160308"
    sha256 "102d41f9e7e56058580215deaf99a068ed00da45fad82d1a2c6cf74abb241b99"
  end

  depends_on "sdl"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-x",
                          "--enable-readline"
    system "make"

    # We need to run 'make install' without parallelization, because
    # of a race that may cause the 'install' utility to fail when
    # two instances concurrently create the same parent directories.
    ENV.deparallelize
    system "make", "install"
  end

  test do
    system "#{bin}/pce-ibmpc", "-V"
  end
end
