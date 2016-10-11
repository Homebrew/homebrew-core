class Mvtools < Formula
  desc "Filters for motion estimation and compensation"
  homepage "https://github.com/dubhater/vapoursynth-mvtools"
  url "https://github.com/dubhater/vapoursynth-mvtools/archive/v16.tar.gz"
  sha256 "22232d5684bf144408ed0e463e2475a90d7ea9e9c7f3c13b92f60452037b07b3"
  head "https://github.com/dubhater/vapoursynth-mvtools.git"

  bottle do
    cellar :any
    sha256 "8388077bcd71b278b5988b9b6904290ced33a076ed88d4d2b68a42950e3204e3" => :sierra
    sha256 "13244f8b967e3369301f3e67cd63d9b2a489ce3dcf5d7e891f7e3ce181b35fe5" => :el_capitan
    sha256 "328dad095637c33a3cc63b95760e41c13ae38b079a749cbea5a42cf40764b9b2" => :yosemite
    sha256 "9552959cda17e51bc207ba8cdeb7b6b7e25e628c9ecc085bc092e2ea83f70ca3" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "yasm" => :build
  depends_on "vapoursynth"
  depends_on "fftw"
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<-EOS.undent
      MVTools will not be autoloaded in your VapourSynth scripts. To use it
      use the following code in your scripts:

        core.std.LoadPlugin(path="#{HOMEBREW_PREFIX}/lib/libmvtools.dylib")
    EOS
  end

  test do
    script = <<-PYTHON.undent.split("\n").join(";")
      import vapoursynth as vs
      core = vs.get_core()
      core.std.LoadPlugin(path="#{HOMEBREW_PREFIX}/lib/libmvtools.dylib")
    PYTHON

    system "python3", "-c", script
  end
end
