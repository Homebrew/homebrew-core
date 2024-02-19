class Ivykis < Formula
  desc "Async I/O-assisting library"
  homepage "https://sourceforge.net/projects/libivykis/"
  url "https://github.com/buytenh/ivykis/archive/refs/tags/v0.43-trunk.tar.gz"
  sha256 "29174b99f45a39bea13f79079d5e17dd58bb800f62e78b44de044715d13d4bdb"
  license "LGPL-2.1-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]trunk)?$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ef3dd26e5ce7524f9383d2a4b04ac39dda04524943c5eb29f4e4ebacec1d223d"
    sha256 cellar: :any,                 arm64_ventura:  "a697da62470856eeaad5092e8082f49c586240af1fbbafbe5fdf668ecc917001"
    sha256 cellar: :any,                 arm64_monterey: "9e28629c45a83f480c21eaebb37b43416f8600345cc84f78be251480e9652c54"
    sha256 cellar: :any,                 sonoma:         "ccc6d0bbb38559ebc9016f3ae8966aeea6eadf99cd3da0fe01e57bbb91e12d35"
    sha256 cellar: :any,                 ventura:        "4767945fe273c9832c5d2a3e7aff1b8eb0b76c5f1ab693becf079bfdf6f7b72a"
    sha256 cellar: :any,                 monterey:       "b8a8642c4dc589444bcd2f2e1a9c48ca115e245f3e6367599c6ef8f868e49d48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "199e983c9cd1d8b28c1a347a4b8760cbacacf9ea99af7bfceb3fee214e049ba1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test_ivykis.c").write <<~EOS
      #include <stdio.h>
      #include <iv.h>
      int main()
      {
        iv_init();
        iv_deinit();
        return 0;
      }
    EOS
    system ENV.cc, "test_ivykis.c", "-L#{lib}", "-livykis", "-o", "test_ivykis"
    system "./test_ivykis"
  end
end
