class Icu4c < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "http://site.icu-project.org/"
  url "https://ssl.icu-project.org/files/icu4c/57.1/icu4c-57_1-src.tgz"
  mirror "https://fossies.org/linux/misc/icu4c-57_1-src.tgz"
  version "57.1"
  sha256 "ff8c67cb65949b1e7808f2359f2b80f722697048e90e7cfc382ec1fe229e9581"

  head "https://ssl.icu-project.org/repos/icu/icu/trunk/", :using => :svn

  bottle do
    cellar :any
    sha256 "e48b889957aec71bcd3f437e13489a17ba39bdd71ff38a18d5858c48bfd404ec" => :sierra
    sha256 "c244860b11f70115cecc19a81566232de900dd2f9d049555c77db3744087ca2a" => :el_capitan
    sha256 "1a18b7c039316fee2376565085c71cb141cae0e5a9680c69b2ca0e8e6d32ce58" => :yosemite
    sha256 "cadba844e31de5cf9a1f9d05dc8671662cfb52610c7ce92f1fef6e3617dee2ea" => :mavericks
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
