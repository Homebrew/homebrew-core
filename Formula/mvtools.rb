class Mvtools < Formula
  desc "Filters for motion estimation and compensation"
  homepage "https://github.com/dubhater/vapoursynth-mvtools"
  url "https://github.com/dubhater/vapoursynth-mvtools/archive/v19.tar.gz"
  sha256 "41848bf526f1807e6894513534d5243bbce5b796d798a3cf47f617229d7b6e9e"
  head "https://github.com/dubhater/vapoursynth-mvtools.git"

  bottle do
    cellar :any
    sha256 "3dd4f5e61df28a742322bc13a0b4c8390cb544ec9dd74e9d2699be9a3522ea3d" => :high_sierra
    sha256 "a1e8772b4d9306f46c6639d37668565ccadbe7bd702190a252275d4d98e70095" => :sierra
    sha256 "0da949dba3b2e7fffee8cc70b4848bb0dea404476636333db22f889347b0b6aa" => :el_capitan
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
