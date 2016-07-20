class Bmon < Formula
  desc "Interface bandwidth monitor"
  homepage "https://github.com/tgraf/bmon"
  url "https://github.com/tgraf/bmon/releases/download/v3.9/bmon-3.9.tar.gz"
  sha256 "9c08332520497ef1d51a733ca531ffedbb5a30c7c3f55579efe86c36138f93e1"

  bottle do
    sha256 "656220781bed16f2b95f8644bbf853d47fe9006d49d63db7fe89db794c9afdb7" => :el_capitan
    sha256 "f5dafdb632d98aaeaebfff0fb3701715ce90858c28a2521257e5509958cf1525" => :yosemite
    sha256 "56d69cb7519759d2da860407d8d12412334acce8d5083bad10bc02688918ba53" => :mavericks
  end

  head do
    url "https://github.com/tgraf/bmon.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "confuse" => :linked

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system bin/"bmon", "-o", "ascii:quitafter=1"
  end
end
