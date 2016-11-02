class Icu4c < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "http://site.icu-project.org/"
  url "https://ssl.icu-project.org/files/icu4c/58.1/icu4c-58_1-src.tgz"
  mirror "https://nuxi.nl/distfiles/third_party/icu4c-58_1-src.tgz"
  version "58.1"
  sha256 "0eb46ba3746a9c2092c8ad347a29b1a1b4941144772d13a88667a7b11ea30309"

  head "https://ssl.icu-project.org/repos/icu/icu/trunk/", :using => :svn

  bottle do
    cellar :any
    sha256 "7d01fd5b88395a4e9861e5c8647e20d6a0ab6a6c6c833106ffec59a19d71a0b1" => :sierra
    sha256 "424f29a78bbe86e1ee4d2a22bea721a0400d3138c84104a3e2e550a05f93ef13" => :el_capitan
    sha256 "7aba0d069ec70819108665c85f446a6e90b98ae4ad256a7b498394e9a0984026" => :yosemite
  end

  keg_only :provided_by_osx, "macOS provides libicucore.dylib (but nothing else)."

  option :universal
  option :cxx11

  def install
    ENV.universal_binary if build.universal?
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
