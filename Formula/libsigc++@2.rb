class LibsigcxxAT2 < Formula
  desc "Callback framework for C++"
  homepage "https://libsigcplusplus.github.io/libsigcplusplus/"
  url "https://download.gnome.org/sources/libsigc++/2.10/libsigc++-2.10.2.tar.xz"
  sha256 "b1ca0253379596f9c19f070c83d362b12dfd39c0a3ea1dd813e8e21c1a097a98"

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
