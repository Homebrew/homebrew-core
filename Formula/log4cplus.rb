class Log4cplus < Formula
  desc "Logging Framework for C++"
  homepage "https://sourceforge.net/p/log4cplus/wiki/Home/"
  url "https://downloads.sourceforge.net/project/log4cplus/log4cplus-stable/1.2.1/log4cplus-1.2.1.tar.xz"
  sha256 "09899274d18af7ec845ef2c36a86b446a03f6b0e3b317d96d89447007ebed0fc"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a32fb37a5b77c193fe5899fd95a2e667aadd0bb8ea327720dd4541688be9e68c" => :high_sierra
    sha256 "2700ad2592a6570da29cde5cedf7f0d437b8be4c79214190aded36984ed80a2b" => :sierra
    sha256 "18d60273182074d9c017f5b2cb3fa5d2827119eb7d7ac403f5de741c9406f3ce" => :el_capitan
  end

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
