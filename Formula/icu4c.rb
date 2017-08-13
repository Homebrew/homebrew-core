class Icu4c < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "http://site.icu-project.org/"
  url "https://ssl.icu-project.org/files/icu4c/59.1/icu4c-59_1-src.tgz"
  mirror "https://fossies.org/linux/misc/icu4c-59_1-src.tgz"
  mirror "https://downloads.sourceforge.net/project/icu/ICU4C/59.1/icu4c-59_1-src.tgz"
  version "59.1"
  sha256 "7132fdaf9379429d004005217f10e00b7d2319d0fea22bdfddef8991c45b75fe"
  head "https://ssl.icu-project.org/repos/icu/trunk/icu4c/", :using => :svn

  bottle do
    cellar :any
    sha256 "5d35bdb7234e637e8a48ecb96178059b68259a9a16e3c5cc9a8bc9ff935ebbc3" => :sierra
    sha256 "e6bd825d866b1edbf76a106cb4a216ed0d99b0e2c92362fbe7913c2c56b85baa" => :el_capitan
    sha256 "4f824506bcbe3732943f6bb717c496ebb0753d5679e5c5855535fc9f93a24fdb" => :yosemite
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
