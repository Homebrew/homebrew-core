class Pce < Formula
  desc "PC emulator"
  homepage "http://www.hampa.ch/pce/"
  url "http://www.hampa.ch/pub/pce/pce-0.2.2.tar.gz"
  sha256 "a8c0560fcbf0cc154c8f5012186f3d3952afdbd144b419124c09a56f9baab999"
  revision 2
  head "git://git.hampa.ch/pce.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ac061de748e0b6bba56957a0b712c65b380d02b4bbc8314a610dee3f6c780e8e"
    sha256 cellar: :any,                 arm64_big_sur:  "c65bf1ca8a8b83b77fd383807fd783696ce9167b1c54b7a03452b6954cfc7733"
    sha256 cellar: :any,                 monterey:       "347b4b3c1fce486b29e8123c4511025e4f9e1907171de26f42d65f4fc32216be"
    sha256 cellar: :any,                 big_sur:        "554c878d6f17167377d677797c295ec5cb65d8e8e5af0ebe320972a42d037c89"
    sha256 cellar: :any,                 catalina:       "de9b733199b55e9cf2cdd0d73643c3ea199d132320600adf81428d08ebfba8af"
    sha256 cellar: :any,                 mojave:         "8c0364c490a9b01875ab9c05c7bc5a6cba190e27d941c72bbbb3e17af71ab88a"
    sha256 cellar: :any,                 high_sierra:    "6c67f811c813423d7380894d6de77aeeeba20d9f18fd36a71653c23b97c433f6"
    sha256 cellar: :any,                 sierra:         "ae09a42321608dfa10291d2a2a1afed87a137c9612a54e513360022de8e908b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b219c1e06cdb370c7865c4e2a39eb50df89889585a7b77320acfb758bbe13696"
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
