class Pce < Formula
  desc "PC emulator"
  homepage "http://www.hampa.ch/pce/"
  url "http://www.hampa.ch/pub/pce/pce-0.2.2.tar.gz"
  sha256 "a8c0560fcbf0cc154c8f5012186f3d3952afdbd144b419124c09a56f9baab999"
  revision 1
  head "git://git.hampa.ch/pce.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "3f23396673ac4fb9df4110cbd9c209a2654527cdfb7464b4700c2db73cee8d76" => :mojave
    sha256 "3fc7f1e16fcd4a351cbb99a1ae73d10de642a145455705d870d176b70c204b32" => :high_sierra
    sha256 "3666d2904f71cdf027dc6c28cb15d269fc1dfed617769d9e4b950d122726f432" => :sierra
  end

  depends_on "nasm" => :build if MacOS.version >= :high_sierra
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
