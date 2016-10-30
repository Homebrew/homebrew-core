class Libsigcxx < Formula
  desc "Callback framework for C++"
  homepage "http://libsigc.sourceforge.net"
  url "https://download.gnome.org/sources/libsigc++/2.10/libsigc++-2.10.0.tar.xz"
  sha256 "f843d6346260bfcb4426259e314512b99e296e8ca241d771d21ac64f28298d81"

  bottle do
    cellar :any
    sha256 "58af260cf09d48886e9e6c8d85d81979ebdaba4abcfa0bbc4a3a9ab3f78dd929" => :sierra
    sha256 "21124a48471cafc82ee203113e368db1b667e4dc6111e66f624af986c88d72ef" => :el_capitan
    sha256 "3441b2001c4e0aa51dae34d36a95db87a580229a6e68ae45f668b3d572a8f9cc" => :yosemite
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
    (testpath/"test.cpp").write <<-EOS.undent
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
