class Mvtools < Formula
  desc "Filters for motion estimation and compensation"
  homepage "https://github.com/dubhater/vapoursynth-mvtools"
  url "https://github.com/dubhater/vapoursynth-mvtools/archive/v23.tar.gz"
  sha256 "3b5fdad2b52a2525764510a04af01eab3bc5e8fe6a02aba44b78955887a47d44"
  license "GPL-2.0"
  revision 1
  head "https://github.com/dubhater/vapoursynth-mvtools.git"

  bottle do
    cellar :any
    sha256 "df691836b6052e38806e3e4a662f0b5da22120f8f586ad6ea388e2673dcf01b3" => :big_sur
    sha256 "01785cf0cea2080cb2b875df545e027aaaf339fbbddeca53fd5dae8f39bf4726" => :catalina
    sha256 "0809f0353e48e30d8628bbe2124cebfa0ebd1a6add77e2d27798ce968dadb84d" => :mojave
    sha256 "0a1bab6b74375cb11959d2100e562bb2cc8124da7115b754975cd70c31e676b2" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
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

        core.std.LoadPlugin(path="#{HOMEBREW_PREFIX}/lib/#{shared_library("libmvtools")}")
    EOS
  end

  test do
    script = <<~EOS.split("\n").join(";")
      import vapoursynth as vs
      core = vs.get_core()
      core.std.LoadPlugin(path="#{lib}/#{shared_library("libmvtools")}")
    EOS

    system Formula["python@3.9"].opt_bin/"python3", "-c", script
  end
end
