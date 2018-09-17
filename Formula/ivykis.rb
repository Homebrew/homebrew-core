class Ivykis < Formula
  desc "Async I/O-assisting library"
  homepage "https://sourceforge.net/projects/libivykis"
  url "https://downloads.sourceforge.net/project/libivykis/0.42.3/ivykis-0.42.3.tar.gz"
  sha256 "c9b025d55cefe9c58958d1012f36d63aa0a5caf22075617fff648751ea940aec"

  bottle do
    cellar :any
    sha256 "9f0368672a79bc905773347bdc45432c4d16edcf84ae7f977141b12723d36d59" => :mojave
    sha256 "a72955a0edfc33235875b785ab262a049a12c46d7b937e382148c62ed191fd1f" => :high_sierra
    sha256 "94e0e10045e3c8cd76b930250f877f9c62e6110e68c074251601174ada0c72e5" => :sierra
    sha256 "83e68479a554c2ca649ce1cd69206d896fa71b9fa81c37835e00cdafa6ecbedd" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
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
