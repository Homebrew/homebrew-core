class LibsigcxxAT2 < Formula
  desc "Callback framework for C++"
  homepage "https://libsigcplusplus.github.io/libsigcplusplus/"
  url "https://download.gnome.org/sources/libsigc++/2.10/libsigc++-2.10.8.tar.xz"
  sha256 "235a40bec7346c7b82b6a8caae0456353dc06e71f14bc414bcc858af1838719a"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f08cb049ca155fb8ac09d1586ea415084ba95e3e2aa760c5b4ddabe51ea44b08"
    sha256 cellar: :any,                 arm64_big_sur:  "5d024a8626df8d8bb872a2e1f1452ebe793f3b95a9c08814abe36a48e9f19297"
    sha256 cellar: :any,                 monterey:       "155cb09e024335504393bc4ea4921348449bbcbf08384f7e6e1210c2cee3f403"
    sha256 cellar: :any,                 big_sur:        "5ea91db7ec5618625126b12e5bf7de2b2d8cc21b77170536f0d9d33de3bc8ffa"
    sha256 cellar: :any,                 catalina:       "f4aa31cd03380890a69669687fee5a978586ea8cd8613e871864f2a5dcc7bd97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a2909597897d782656e62646e426c9e0f29a11d845b986de0f13a0e07adcd77"
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
