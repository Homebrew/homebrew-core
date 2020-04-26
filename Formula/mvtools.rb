class Mvtools < Formula
  desc "Filters for motion estimation and compensation"
  homepage "https://github.com/dubhater/vapoursynth-mvtools"
  url "https://github.com/dubhater/vapoursynth-mvtools/archive/v21.tar.gz"
  sha256 "dc267fce40dd8531a39b5f51075e92dd107f959edb8be567701ca7545ffd35c5"
  revision 1
  head "https://github.com/dubhater/vapoursynth-mvtools.git"

  bottle do
    cellar :any
    sha256 "691236bc8cc5a2a2a67511a5731c98e62a4314feb8cbe0f657a95a61038d82c9" => :catalina
    sha256 "38a737a0f57228a8feafd128cf5124cb563a1579396943c5f3ae28716922ddc9" => :mojave
    sha256 "ddc7826a71b5c15138526db3857afbf16cda335c7037236bd2abe35035c9bcc9" => :high_sierra
    sha256 "397b4e471afb5194b619dc3829bed5bb98739f11c3c188db6e3837d09159063e" => :sierra
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
