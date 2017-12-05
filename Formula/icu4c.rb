class Icu4c < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "http://site.icu-project.org/"
  head "https://ssl.icu-project.org/repos/icu/trunk/icu4c/", :using => :svn

  stable do
    url "https://ssl.icu-project.org/files/icu4c/60.1/icu4c-60_1-src.tgz"
    mirror "https://fossies.org/linux/misc/icu4c-60_1-src.tgz"
    mirror "https://downloads.sourceforge.net/project/icu/ICU4C/60.1/icu4c-60_1-src.tgz"
    version "60.1"
    sha256 "f8f5a6c8fbf32c015a467972bdb1477dc5f5d5dfea908b6ed218715eeb5ee225"

    # Upstream commit "ticket:13462: Fix Script_Extensions for 5 characters"
    # 8 Nov 2017 http://bugs.icu-project.org/trac/changeset/40667
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/8e407d3/icu4c/ticket-13462.diff"
      sha256 "e3338f4ebc86dd6f0fd605e8b8170f013fad46709b495322bfc4be0b1f96cedc"
    end
  end

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
