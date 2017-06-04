class Icu4c < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "http://site.icu-project.org/"
  url "https://ssl.icu-project.org/files/icu4c/58.2/icu4c-58_2-src.tgz"
  mirror "https://fossies.org/linux/misc/icu4c-58_2-src.tgz"
  mirror "https://downloads.sourceforge.net/project/icu/ICU4C/58.2/icu4c-58_2-src.tgz"
  version "58.2"
  sha256 "2b0a4410153a9b20de0e20c7d8b66049a72aef244b53683d0d7521371683da0c"
  head "https://ssl.icu-project.org/repos/icu/trunk/icu4c/", :using => :svn

  bottle do
    cellar :any
    sha256 "779eda1c03f44b54300b5e70143f6bd4866b6f5f582e4216124649539164b029" => :sierra
    sha256 "f8267df67e76db7412baf967dd9ef6e8c625cd207707960a6a2a860e0c07f92b" => :el_capitan
    sha256 "7ce8fa8fba5ba285bfb0278d2e73c01e8d2ff3115a5ad762255cacde6ffeecfb" => :yosemite
  end

  keg_only :provided_by_osx, "macOS provides libicucore.dylib (but nothing else)"

  option :cxx11

  def install
    ENV.cxx11 if build.cxx11?

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
