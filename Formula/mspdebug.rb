class Mspdebug < Formula
  desc "Debugger for use with MSP430 MCUs"
  homepage "http://dlbeer.co.nz/mspdebug/"
  url "https://github.com/dlbeer/mspdebug/archive/v0.25.tar.gz"
  sha256 "347b5ae5d0ab0cddb54363b72abe482f9f5d6aedb8f230048de0ded28b7d1503"

  bottle do
    sha256 "66539d0d14a5aea20add7ca1c9ef3ddd52a3c55f297ef363ac87d5e8637b5fb9" => :sierra
    sha256 "cf344bb3dde57fbed99d121dae7018abe2243ba5151ac2229210e1f2b2be29c8" => :el_capitan
    sha256 "303e0f55100d99ded862be2cced8d9c84d5b1048e44aaf15f013a8b2ed28e857" => :yosemite
    sha256 "0c2ec6054005d777a0da7dfff74d401811fe5d0543b14cd6b02e6e03dc5bd173" => :mavericks
  end

  depends_on "hidapi"
  depends_on "libusb-compat"

  def install
    ENV.append_to_cflags "-I#{Formula["hidapi"].opt_include}/hidapi"
    system "make", "PREFIX=#{prefix}", "install"
  end

  def caveats; <<-EOS.undent
    You may need to install a kernel extension if you're having trouble with
    RF2500-like devices such as the TI Launchpad:
      http://dlbeer.co.nz/mspdebug/faq.html#rf2500_osx
    EOS
  end

  test do
    system bin/"mspdebug", "--help"
  end
end
