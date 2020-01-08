class Pce < Formula
  desc "PC emulator"
  homepage "http://www.hampa.ch/pce/"
  url "http://www.hampa.ch/pub/pce/pce-0.2.2.tar.gz"
  sha256 "a8c0560fcbf0cc154c8f5012186f3d3952afdbd144b419124c09a56f9baab999"
  revision 2
  head "git://git.hampa.ch/pce.git"

  bottle do
    cellar :any
    sha256 "de9b733199b55e9cf2cdd0d73643c3ea199d132320600adf81428d08ebfba8af" => :catalina
    sha256 "8c0364c490a9b01875ab9c05c7bc5a6cba190e27d941c72bbbb3e17af71ab88a" => :mojave
    sha256 "6c67f811c813423d7380894d6de77aeeeba20d9f18fd36a71653c23b97c433f6" => :high_sierra
    sha256 "ae09a42321608dfa10291d2a2a1afed87a137c9612a54e513360022de8e908b3" => :sierra
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
