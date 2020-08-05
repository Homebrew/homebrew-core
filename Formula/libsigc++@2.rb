class LibsigcxxAT2 < Formula
  desc "Callback framework for C++"
  homepage "https://libsigcplusplus.github.io/libsigcplusplus/"
  url "https://download.gnome.org/sources/libsigc++/2.10/libsigc++-2.10.3.tar.xz"
  sha256 "0b68dfc6313c6cc90ac989c6d722a1bf0585ad13846e79746aa87cb265904786"

  bottle do
    cellar :any
    sha256 "bcf678faa58639056292bb201143fe4add755d9f6da6a65f4b7d10cff0ccfe17" => :catalina
    sha256 "034cb3a54d796e4b9ec4619a15612fc64fc7e7cbddf189f71bb5342f7b631a3d" => :mojave
    sha256 "c8cccc56cfb07d96e339af416c7a2449673c5303f15f99c5f668fc4c5f792695" => :high_sierra
  end

  uses_from_macos "m4" => :build

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make"
    system "make", "check"
    system "make", "install"
  end
  test do
    (testpath/"test.cpp").write <<~EOS
      #include <sigc++/sigc++.h>

      void somefunction(int arg) {}

      int main(int argc, char *argv[])
      {
         sigc::slot<void, int> sl = sigc::ptr_fun(&somefunction);
         return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp",
                   "-L#{lib}", "-lsigc-2.0", "-I#{include}/sigc++-2.0", "-I#{lib}/sigc++-2.0/include", "-o", "test"
    system "./test"
  end
end
