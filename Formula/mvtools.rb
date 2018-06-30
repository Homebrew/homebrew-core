class Mvtools < Formula
  desc "Filters for motion estimation and compensation"
  homepage "https://github.com/dubhater/vapoursynth-mvtools"
  url "https://github.com/dubhater/vapoursynth-mvtools/archive/v19.tar.gz"
  sha256 "41848bf526f1807e6894513534d5243bbce5b796d798a3cf47f617229d7b6e9e"
  revision 1
  head "https://github.com/dubhater/vapoursynth-mvtools.git"

  bottle do
    cellar :any
    sha256 "3e05cfa336819c82034eb8cbc6ffdd21e945ad49513db964c28a9891d4416dad" => :high_sierra
    sha256 "e9c4726e6f4f63b6b7f19097f11d1aefc5ee2ebb02e1ce904430b0f2021ea476" => :sierra
    sha256 "5adaa21a07181d6ae19b102d49a84797c60abd9ee50178ab07da2e27e7ee9b21" => :el_capitan
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
