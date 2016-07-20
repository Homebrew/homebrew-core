class Bmon < Formula
  desc "Interface bandwidth monitor"
  homepage "https://github.com/tgraf/bmon"
  url "https://github.com/tgraf/bmon/releases/download/v3.9/bmon-3.9.tar.gz"
  sha256 "9c08332520497ef1d51a733ca531ffedbb5a30c7c3f55579efe86c36138f93e1"

  bottle do
    sha256 "7215050b89d4cbf877365c7a66885ca80be97f94b0cace93dc51cc1b29c2108e" => :el_capitan
    sha256 "576b5d70844675bcf7dfa15df9e7b69065e2c951dbb52e1b156215e8a8ddd93c" => :yosemite
    sha256 "1f170230b89afb2a9761cb30283a7cfdc18468e6df7e4744fc882d60bb67852d" => :mavericks
    sha256 "84e9754b63dd5133669d7194ceab9ae36b90f4af5e05f77a9f1ed9e744121802" => :mountain_lion
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
