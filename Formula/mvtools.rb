class Mvtools < Formula
  desc "Filters for motion estimation and compensation"
  homepage "https://github.com/dubhater/vapoursynth-mvtools"
  url "https://github.com/dubhater/vapoursynth-mvtools/archive/v23.tar.gz"
  sha256 "3b5fdad2b52a2525764510a04af01eab3bc5e8fe6a02aba44b78955887a47d44"
  head "https://github.com/dubhater/vapoursynth-mvtools.git"

  bottle do
    cellar :any
    sha256 "4f37597f1c6d47ca51fe0d6ba4935eafc6326de6ccbcc489a7873540a867d7ea" => :catalina
    sha256 "99c7c063c8a28be18c1d121d0dcca4bc54a0f693b1ab22035f02c25100075610" => :mojave
    sha256 "b29cbe91c882323a3e5e14526b1bef4da076a838c4696ef4c634d09505a2ab3c" => :high_sierra
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

    system Formula["python@3.8"].opt_bin/"python3", "-c", script
  end
end
