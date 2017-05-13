class Mvtools < Formula
  desc "Filters for motion estimation and compensation"
  homepage "https://github.com/dubhater/vapoursynth-mvtools"
  url "https://github.com/dubhater/vapoursynth-mvtools/archive/v18.tar.gz"
  sha256 "1cfd1b11ada04c0381b90b9561362d8e6b58cc0a0592925e2564b2bf36b5046c"
  head "https://github.com/dubhater/vapoursynth-mvtools.git"

  bottle do
    cellar :any
    sha256 "1d2d644ffc126d9ee1d8d61c23de36e623cfb37c4419202f72e84bbd08a4d20b" => :sierra
    sha256 "bae3ee68c55a7f4fe2ba81017e49e3da772c88b157e7f8505f59b95acf1e5660" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "yasm" => :build
  depends_on "vapoursynth"
  depends_on "fftw"
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on :macos => :el_capitan # due to zimg

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
      core.std.LoadPlugin(path="#{lib}/libmvtools.dylib")
    PYTHON

    system "python3", "-c", script
  end
end
