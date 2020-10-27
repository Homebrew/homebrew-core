class LibsigcxxAT2 < Formula
  desc "Callback framework for C++"
  homepage "https://libsigcplusplus.github.io/libsigcplusplus/"
  url "https://download.gnome.org/sources/libsigc++/2.10/libsigc++-2.10.4.tar.xz"
  sha256 "1f5874358d9a21379024a4f4edba80a8a3aeb33f0531b192a6b1c35ed7dbfa3e"
  license "LGPL-3.0-or-later"

  bottle do
    cellar :any
    sha256 "7154ac476939a124a9fce607a2e04179f769a942e4faac24f9e15d4e408d0bb1" => :catalina
    sha256 "2ed859eacbb9d12487be891f1b3f06b1b5fffb1ccac3af37787ac174fabd934d" => :mojave
    sha256 "0b46ff09499e252f0821f22cc1deff57a332130a807928bd018bdb4145705bac" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  # submitted upstream at https://github.com/libsigcplusplus/libsigcplusplus/pull/65
  patch do
    url "https://github.com/libsigcplusplus/libsigcplusplus/commit/2a7c936dfe4e5327372c17f8c45e333b5728608f.patch?full_index=1"
    sha256 "bdac66d120906e355f3403c15e74ba931229c833fb4ad97888c475d71d02171c"
  end

  def install
    ENV.cxx11

    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
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
