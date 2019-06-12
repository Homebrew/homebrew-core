class Libsigcxx < Formula
  desc "Callback framework for C++"
  homepage "https://libsigcplusplus.github.io/libsigcplusplus/"
  url "https://download.gnome.org/sources/libsigc++/2.10/libsigc++-2.10.2.tar.xz"
  sha256 "b1ca0253379596f9c19f070c83d362b12dfd39c0a3ea1dd813e8e21c1a097a98"

  bottle do
    cellar :any
    sha256 "e969efb989c5ec1cd2d024bed7836a46f4edc0b517d11b8d9df4a1fb196eb901" => :mojave
    sha256 "3682ee57f364d08e9381c4dbb80438e3fb9194284defabf28f3d2eba8195f63c" => :high_sierra
    sha256 "e68c8c1b8406b34956d4918cfa1b6717ceb1201732da759be9a2601cc60230e4" => :sierra
  end

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
