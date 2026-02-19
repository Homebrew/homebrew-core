class LibsigcxxAT2 < Formula
  desc "Callback framework for C++"
  homepage "https://libsigcplusplus.github.io/libsigcplusplus/"
  url "https://github.com/libsigcplusplus/libsigcplusplus/releases/download/2.12.1/libsigc++-2.12.1.tar.xz"
  sha256 "a9dbee323351d109b7aee074a9cb89ca3e7bcf8ad8edef1851f4cf359bd50843"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/^v?(2\.([0-8]\d*?)?[02468](?:\.\d+)*?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ce0968768e01d7083aae67a5909ba21931e45815f89b974cffda25aa8a694bef"
    sha256 cellar: :any,                 arm64_sequoia: "0eb7a34afb68af5d9ea00a5d0211d4768d3e90bbf16c286b450e682ec7c007af"
    sha256 cellar: :any,                 arm64_sonoma:  "af4c5de76ebf9469808c9c278dbe877160125e0121757234d212a3841a01b2ac"
    sha256 cellar: :any,                 sonoma:        "164f7457cb79b279f2c34c289304261175501b7ad9de59a619fe9dd8a9c771ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08f2f15b878a71707163d2f49adda77e59e4015cad55dac1d54bda3d33224f1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17c1833149605fcedee3881382f8a4bf7e961283ea9c2532ff0e1b6785639fb7"
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
