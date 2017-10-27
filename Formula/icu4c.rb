class Icu4c < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "http://site.icu-project.org/"
  revision 1
  head "https://ssl.icu-project.org/repos/icu/trunk/icu4c/", :using => :svn

  stable do
    url "https://ssl.icu-project.org/files/icu4c/59.1/icu4c-59_1-src.tgz"
    mirror "https://fossies.org/linux/misc/icu4c-59_1-src.tgz"
    mirror "https://downloads.sourceforge.net/project/icu/ICU4C/59.1/icu4c-59_1-src.tgz"
    version "59.1"
    sha256 "7132fdaf9379429d004005217f10e00b7d2319d0fea22bdfddef8991c45b75fe"

    # Fix CVE-2017-14952
    # Upstream commit from 9 Aug 2017 "Removed redundant UVector entry clean up
    # function call."
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/fb441ea/icu4c/CVE-2017-14952.diff"
      sha256 "1da1eec19cfe4907eb4766192ddbca689506ce44cfeb35c349af9609ae7f7203"
    end
  end

  bottle do
    cellar :any
    sha256 "f03168a285d1b2ee092e527655c0d78ffe9aa10f800d4a4d11a9bfdc0deb6315" => :high_sierra
    sha256 "6b316939ae2710a280af39c1764bcb710867546adb70c5452f3ba4c8e5e88093" => :sierra
    sha256 "7e60800e678246480fcafdfa1da958c8ec2363bb184e776cddad5388879832f7" => :el_capitan
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
