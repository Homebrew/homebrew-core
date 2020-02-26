class LibsigcxxAT2 < Formula
  desc "Callback framework for C++"
  homepage "https://libsigcplusplus.github.io/libsigcplusplus/"
  url "https://download.gnome.org/sources/libsigc++/2.10/libsigc++-2.10.2.tar.xz"
  sha256 "b1ca0253379596f9c19f070c83d362b12dfd39c0a3ea1dd813e8e21c1a097a98"

  bottle do
    cellar :any
    sha256 "03c0627d1d5cfd7c84cae86c7536e6ad43f2ad73bdf6d92258ec68b12ef81e59" => :catalina
    sha256 "cfb591da46f83d5242f860533bb509e4966b32f45d96abd1aebe60ccce536de6" => :mojave
    sha256 "81130d69dd341e31f941f9d457745bbefb4eb59427a81c014e5cf6c1c8b861ad" => :high_sierra
    sha256 "d9c71c15b7d4d244aa74aa319a14f0bba110ca97160abe035a461409b2b1630b" => :sierra
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
