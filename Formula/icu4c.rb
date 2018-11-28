class Icu4c < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "https://ssl.icu-project.org/"
  url "https://ssl.icu-project.org/files/icu4c/63.1/icu4c-63_1-src.tgz"
  mirror "https://github.com/unicode-org/icu/releases/download/release-63-1/icu4c-63_1-src.tgz"
  version "63.1"
  sha256 "05c490b69454fce5860b7e8e2821231674af0a11d7ef2febea9a32512998cb9d"

  bottle do
    cellar :any
    sha256 "29ee03c6a5c0754ff90f1618c75a851193e0a8a003b6f18c5673aa0003c2a313" => :mojave
    sha256 "d1c24fa3df7e89935554ebcdbc6de6363cab0d264f01902db17eda35d8df0333" => :high_sierra
    sha256 "a4d77bbdd2613440a8a49f1091c82cbcad6ba6538a72ffd1765c104a23b84f32" => :sierra
    sha256 "6936900be3acec316cc0d05c5fa0a07d727a2b7a3fd736bc5fd1db2be9798cb8" => :el_capitan
  end

  keg_only :provided_by_macos, "macOS provides libicucore.dylib (but nothing else)"

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
