class Icu4c < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "http://site.icu-project.org/"
  url "https://ssl.icu-project.org/files/icu4c/59.1/icu4c-59_1-src.tgz"
  mirror "https://fossies.org/linux/misc/icu4c-59_1-src.tgz"
  version "59.1"
  sha256 "7132fdaf9379429d004005217f10e00b7d2319d0fea22bdfddef8991c45b75fe"
  head "https://ssl.icu-project.org/repos/icu/trunk/icu4c/", :using => :svn

  bottle do
    cellar :any
    sha256 "779eda1c03f44b54300b5e70143f6bd4866b6f5f582e4216124649539164b029" => :sierra
    sha256 "f8267df67e76db7412baf967dd9ef6e8c625cd207707960a6a2a860e0c07f92b" => :el_capitan
    sha256 "7ce8fa8fba5ba285bfb0278d2e73c01e8d2ff3115a5ad762255cacde6ffeecfb" => :yosemite
  end

  keg_only :provided_by_osx, "macOS provides libicucore.dylib (but nothing else)."

  needs :cxx11

  def install
    ENV.cxx11

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
