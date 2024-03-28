class Pangomm < Formula
  desc "C++ interface to Pango"
  homepage "https://www.pango.org/"
  url "https://download.gnome.org/sources/pangomm/2.52/pangomm-2.52.0.tar.xz"
  sha256 "34a134126a6484ff12f774358c36ecc44d0e9df094e1b83796d9774bb7d24947"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "c190b7406547e70fc3f79e34f9e66c677b8be641ec52a76139755ec45d2399bf"
    sha256 cellar: :any, arm64_ventura:  "1cba18840fc171623c4ee6aaf42f15d8276b99a6c82616091f6a4061ad05a337"
    sha256 cellar: :any, arm64_monterey: "23f8b644129de1ce573ad7bddec586a5e4103aedcc1ecad375318ff5215b5ae6"
    sha256 cellar: :any, sonoma:         "393e4b9ed7dfdfd4276478bbad7aaac533857277ef3e2f48b5bf5f500a0b095f"
    sha256 cellar: :any, ventura:        "a9947704abbdd99b3a528f03a4f5c7c1e89081c6f0c50e470c437d38e2fbc0d0"
    sha256 cellar: :any, monterey:       "736bd3839ce9b1d7e3206acdbb89f7fa2cbc63efda141026518017303b2af91e"
    sha256               x86_64_linux:   "54f2c185939b1aebe91b3f0f598076435db1bf863ed6b093736746412fdce4d9"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "cairomm"
  depends_on "glibmm"
  depends_on "pango"

  fails_with gcc: "5"

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

    pkg_config_cflags = shell_output("pkg-config --cflags --libs pangomm-2.48").chomp.split
    system ENV.cxx, "-std=c++17", "test.cpp", *pkg_config_cflags, "-o", "test"
    system "./test"
  end
end
