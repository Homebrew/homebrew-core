class PangommAT246 < Formula
  desc "C++ interface to Pango"
  homepage "https://www.pango.org/"
  url "https://download.gnome.org/sources/pangomm/2.46/pangomm-2.46.4.tar.xz"
  sha256 "b92016661526424de4b9377f1512f59781f41fb16c9c0267d6133ba1cd68db22"
  license "LGPL-2.1-only"

  livecheck do
    url :stable
    regex(/pangomm-(2\.46(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "3cf37600a12ca5691e1d64c0f7572bfb45e0c643d63fb8936b766cbae72d0df4"
    sha256 cellar: :any, arm64_ventura:  "ef7f19ac203a1a078fa13ae8aaae8e18e9c556ceab1058788c3aa9614693d8f4"
    sha256 cellar: :any, arm64_monterey: "11178d48ea9263be36a481a52e51f1b9e2b44b39edbe9c766eb29e54cc68b663"
    sha256 cellar: :any, sonoma:         "f42c650716f05968becd9918aaf5ca74f8a8f0826181d5618358f94f3a7c042d"
    sha256 cellar: :any, ventura:        "08bad306d38ff22f21682b3871a34f3e05bbb31a241727638bd4be7d15b6a5e1"
    sha256 cellar: :any, monterey:       "fe4f2c198e5a74c30d053024a6294655ae945b86885fdf2699618f0d10b27e37"
    sha256               x86_64_linux:   "8d8758b6e19e684ef9db90d3ae3413503798cb0c15a7df7f8981a6dcf84bf223"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "cairomm@1.14"
  depends_on "glibmm@2.66"
  depends_on "pango"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end
  test do
    (testpath/"test.cpp").write <<~EOS
      #include <pangomm.h>
      int main(int argc, char *argv[])
      {
        Pango::FontDescription fd;
        return 0;
      }
    EOS

    pkg_config_cflags = shell_output("pkg-config --cflags --libs pangomm-1.4").chomp.split
    system ENV.cxx, "-std=c++11", "test.cpp", *pkg_config_cflags, "-o", "test"
    system "./test"
  end
end
