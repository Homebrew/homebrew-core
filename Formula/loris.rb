class Loris < Formula
  desc "Audio analysis, manipulation and synthesis"
  homepage "http://www.cerlsoundgroup.org/Loris"
  url "https://github.com/MatthiasWinkelmann/loris/archive/1.9.tar.gz"
  sha256 "94b894c05b31a59d08fe23b8403e1df3dc8b876acffe21d38a393a27775da2ac"

  depends_on "fftw"
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./reconf"
    system "./configure", "--prefix=#{prefix}", "--with-python=no"
    system "make", "install"
  end

  test do
    system "echo 'testing testing 1 2 3' | #{bin}/loris-analyze 50 -o /dev/null -verbose"
  end
end
