class LibsigcxxAT2 < Formula
  desc "Callback framework for C++"
  homepage "https://libsigcplusplus.github.io/libsigcplusplus/"
  url "https://github.com/libsigcplusplus/libsigcplusplus/releases/download/2.12.2/libsigc++-2.12.2.tar.xz"
  sha256 "7d4cdf1e4332ebfee8085ad960075045e7763cb291b3ccf4744d7cbf08a22b75"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(2\.([0-8]\d*?)?[02468](?:\.\d+)*?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8e580d27768484f5dd755531d25ded0d2e36d49152601af692fdeec939fe0a1c"
    sha256 cellar: :any,                 arm64_sequoia: "6ca9585abc36d3fa9699c5c0e8951f9ed0c70db8c6d1f8d14efb77beb21ae4c8"
    sha256 cellar: :any,                 arm64_sonoma:  "7bbfc74590d6075e5855ecf9fef009dd4fcb19f107e8dd2433308721b51a8819"
    sha256 cellar: :any,                 sonoma:        "4559e283eeeb813f3c10731c39d071aacd785071328973b6f6db51b682177ef0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2eace468727cfef91725a8ee20431650d6cda00abc7e540812ef598adb20274"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2265b389d5c0f4452238783cf1d7c970fe647b7a2cc7182675f013f724a0ce3b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <sigc++/sigc++.h>

      void somefunction(int arg) {}

      int main(int argc, char *argv[])
      {
         sigc::slot<void, int> sl = sigc::ptr_fun(&somefunction);
         return 0;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp",
                   "-L#{lib}", "-lsigc-2.0", "-I#{include}/sigc++-2.0", "-I#{lib}/sigc++-2.0/include", "-o", "test"
    system "./test"
  end
end
