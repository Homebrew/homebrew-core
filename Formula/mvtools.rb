class Mvtools < Formula
  desc "Filters for motion estimation and compensation"
  homepage "https://github.com/dubhater/vapoursynth-mvtools"
  url "https://github.com/dubhater/vapoursynth-mvtools/archive/v20.tar.gz"
  sha256 "9a1bc87b9bad6642dd7d69b1b6e200c1d962ef55fc2787581e5d2cb437aa0b23"
  head "https://github.com/dubhater/vapoursynth-mvtools.git"

  bottle do
    cellar :any
    sha256 "9ed185ad8294c1a18115e38d99dfbe0752849038c333b684d1e6642cc3377bc0" => :mojave
    sha256 "6a78a79719c00934f397bf61a6fff3415fa3ca155bb22cf67b3ae899f718174b" => :high_sierra
    sha256 "bd36ea3bb4a0e0ee16892683dbd3d5e04bd7b11174f99d5a698b6c495158f81e" => :sierra
    sha256 "043f36d3ed835c973bbacb64aa07cb2f435fb10539f2b7cb0feecdf75a459f72" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on :macos => :el_capitan # due to zimg
  depends_on "vapoursynth"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      MVTools will not be autoloaded in your VapourSynth scripts. To use it
      use the following code in your scripts:

        core.std.LoadPlugin(path="#{HOMEBREW_PREFIX}/lib/libmvtools.dylib")
    EOS
  end

  test do
    script = <<~EOS.split("\n").join(";")
      import vapoursynth as vs
      core = vs.get_core()
      core.std.LoadPlugin(path="#{lib}/libmvtools.dylib")
    EOS

    system "python3", "-c", script
  end
end
