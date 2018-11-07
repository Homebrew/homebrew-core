class Pce < Formula
  desc "PC emulator"
  homepage "http://www.hampa.ch/pce/"
  url "http://www.hampa.ch/pub/pce/pce-0.2.2.tar.gz"
  sha256 "a8c0560fcbf0cc154c8f5012186f3d3952afdbd144b419124c09a56f9baab999"
  revision 1
  head "git://git.hampa.ch/pce.git"

  bottle do
    cellar :any
    sha256 "43d68fb33e9edfb191d49c5966954f30dd9805b793b8fe31f2f53c4e0b3306a1" => :high_sierra
    sha256 "5eac356a0cc4e27d748c3eaaba446f64005dd45cfdc7b7be915bdf186eb01655" => :sierra
    sha256 "8574731084cdd4efd9394e7b92d262e80dcb23dc5d9d8bc14746c81ea9f66bcf" => :el_capitan
    sha256 "5166b5f8b91d05e8d45f8683326e865cb75e2f574dff790d423ac4f4215d51f5" => :yosemite
  end

  depends_on "readline"
  depends_on "sdl"

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
