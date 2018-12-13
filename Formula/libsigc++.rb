class Libsigcxx < Formula
  desc "Callback framework for C++"
  homepage "https://libsigcplusplus.github.io/libsigcplusplus/"
  url "https://download.gnome.org/sources/libsigc++/2.10/libsigc++-2.10.1.tar.xz"
  sha256 "c9a25f26178c6cbb147f9904d8c533b5a5c5111a41ac2eb781eb734eea446003"

  bottle do
    cellar :any
    sha256 "3a25321fd5ddcfce8d4e640869f73bf92dc809f234ded7fc35c374c34d569eef" => :mojave
    sha256 "230a6bf532a8a33f9e532c6534fbb0922aea0dc337b1148ba395b3078e780a52" => :high_sierra
    sha256 "c0183cda1eafe9542d87a47e986c1efb02b82c747e5f466a4ddd5cff9ac4c6a1" => :sierra
  end

  needs :cxx11

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
