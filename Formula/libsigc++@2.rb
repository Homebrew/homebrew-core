class LibsigcxxAT2 < Formula
  desc "Callback framework for C++"
  homepage "https://libsigcplusplus.github.io/libsigcplusplus/"
  url "https://download.gnome.org/sources/libsigc++/2.10/libsigc++-2.10.7.tar.xz"
  sha256 "d082a2ce72c750f66b1a415abe3e852df2eae1e8af53010f4ac2ea261a478832"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6b6ee5de019405fdc5b58a8b8761f60c3fe8d64a916999a0ad39a96117aab9ea"
    sha256 cellar: :any,                 arm64_big_sur:  "3592c888aba18303eaa7e7837a27e386e311bac18684b613f705917ca6356ed6"
    sha256 cellar: :any,                 monterey:       "5cba3fb26934f5f573872a72741b08261619e8e73eebe4384e2266b87ad2af4a"
    sha256 cellar: :any,                 big_sur:        "c24567ac4b9a732a434afcadda0d1a02f573607c73ebb00625e8ffcc6506f331"
    sha256 cellar: :any,                 catalina:       "6a51eeae589ad4511165b0236a64a7055315eafcf790fcc1ed3df24853fe4bdb"
    sha256 cellar: :any,                 mojave:         "38886af39d68b304c8e9f4eac36f6a5e6bd21b79ee9a353df7266649f0490128"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c36d5580b4f8970a6db2027820bbf1eb3cca66f56fbf8c56b32c72c3a23cc6c"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

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
