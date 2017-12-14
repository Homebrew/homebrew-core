class Icu4c < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "http://site.icu-project.org/"
  url "https://ssl.icu-project.org/files/icu4c/60.2/icu4c-60_2-src.tgz"
  mirror "https://fossies.org/linux/misc/icu4c-60_2-src.tgz"
  mirror "https://downloads.sourceforge.net/project/icu/ICU4C/60.2/icu4c-60_2-src.tgz"
  version "60.2"
  sha256 "f073ea8f35b926d70bb33e6577508aa642a8b316a803f11be20af384811db418"
  head "https://ssl.icu-project.org/repos/icu/trunk/icu4c/", :using => :svn

  bottle do
    cellar :any
    sha256 "e15405fead705403edfc87b9b0ed74d1e123388563904aac84f3a839f9e4124c" => :high_sierra
    sha256 "3dacf3b81a23dc0388251bfb91863c883f14d92633874f334b36da7ce5a5f726" => :sierra
    sha256 "a9f727700195d125893d034981d287b0a290114c41850cd904882c00700c535d" => :el_capitan
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
