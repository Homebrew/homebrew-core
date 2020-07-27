class Mvtools < Formula
  desc "Filters for motion estimation and compensation"
  homepage "https://github.com/dubhater/vapoursynth-mvtools"
  url "https://github.com/dubhater/vapoursynth-mvtools/archive/v23.tar.gz"
  sha256 "3b5fdad2b52a2525764510a04af01eab3bc5e8fe6a02aba44b78955887a47d44"
  license "GPL-2.0"
  head "https://github.com/dubhater/vapoursynth-mvtools.git"

  bottle do
    cellar :any
    sha256 "0da74491af99cf7cb20d4387d449af550b94abdf6f5330fd95da083689bb80b0" => :catalina
    sha256 "9349ea16136c2d54c9f132af9e5c1768f486ce4ed6bcababf3f1f2f1944a7389" => :mojave
    sha256 "d8dfbb4ea0e148a954fb50745230b3827f4e02457d739599d2fdec76e31058d8" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on macos: :el_capitan # due to zimg
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

    system Formula["python@3.8"].opt_bin/"python3", "-c", script
  end
end
