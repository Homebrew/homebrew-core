class Icu4c < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "http://site.icu-project.org/"
  url "https://ssl.icu-project.org/files/icu4c/60.2/icu4c-60_2-src.tgz"
  mirror "https://downloads.sourceforge.net/project/icu/ICU4C/60.2/icu4c-60_2-src.tgz"
  version "60.2"
  sha256 "f073ea8f35b926d70bb33e6577508aa642a8b316a803f11be20af384811db418"
  head "https://ssl.icu-project.org/repos/icu/trunk/icu4c/", :using => :svn

  bottle do
    cellar :any
    sha256 "cd6252141fd00076f67a01daceec4c5dfdea033c6a63b1a0ea7c98653757eb48" => :high_sierra
    sha256 "2d8e104b3346632e091386e8640d2f3033e38654341b9a670d334832b1432c11" => :sierra
    sha256 "54cc020520f422f5a708b20e1bec4e009cb7a52e7a150a3dd8edcfaa4f591200" => :el_capitan
  end

  keg_only :provided_by_osx, "macOS provides libicucore.dylib (but nothing else)"

  def install
    args = %W[--prefix=#{prefix} --disable-samples --disable-tests --enable-static]
    args << "--with-library-bits=64" if MacOS.prefer_64_bit?

    cd "source" do
      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/gendict", "--uchars", "/usr/share/dict/words", "dict"
  end
end
