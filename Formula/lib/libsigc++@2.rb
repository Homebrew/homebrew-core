class LibsigcxxAT2 < Formula
  desc "Callback framework for C++"
  homepage "https://libsigcplusplus.github.io/libsigcplusplus/"
  url "https://download.gnome.org/sources/libsigc++/2.10/libsigc++-2.10.8.tar.xz"
  sha256 "235a40bec7346c7b82b6a8caae0456353dc06e71f14bc414bcc858af1838719a"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "60b84e4af2ddcceecaed25095c2dd11efd191c3a96d7c39b08552fcfaeca82ad"
    sha256 cellar: :any,                 arm64_sonoma:   "d84c23bbe72a865f26ed4426a029b5a4a2ae9f4410a446737469e463be28f353"
    sha256 cellar: :any,                 arm64_ventura:  "c3faa72283c90172978072aae40c1f7cc75ebecdc58cbb292f50759c2f6a0f50"
    sha256 cellar: :any,                 arm64_monterey: "f08cb049ca155fb8ac09d1586ea415084ba95e3e2aa760c5b4ddabe51ea44b08"
    sha256 cellar: :any,                 arm64_big_sur:  "5d024a8626df8d8bb872a2e1f1452ebe793f3b95a9c08814abe36a48e9f19297"
    sha256 cellar: :any,                 sonoma:         "fc7f210956e4996bb337ce6cf5d7a57699e2e212a6c33bf27f0e74c9bcf3eefb"
    sha256 cellar: :any,                 ventura:        "9c65d0d59d9f38882611c7f19433d78dd72ff1b13336137c602ce0a031360ca7"
    sha256 cellar: :any,                 monterey:       "155cb09e024335504393bc4ea4921348449bbcbf08384f7e6e1210c2cee3f403"
    sha256 cellar: :any,                 big_sur:        "5ea91db7ec5618625126b12e5bf7de2b2d8cc21b77170536f0d9d33de3bc8ffa"
    sha256 cellar: :any,                 catalina:       "f4aa31cd03380890a69669687fee5a978586ea8cd8613e871864f2a5dcc7bd97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a2909597897d782656e62646e426c9e0f29a11d845b986de0f13a0e07adcd77"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
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
