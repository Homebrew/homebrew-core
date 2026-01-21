class Cairomm < Formula
  desc "Vector graphics library with cross-device output support"
  homepage "https://cairographics.org/cairomm/"
  url "https://cairographics.org/releases/cairomm-1.18.0.tar.xz"
  sha256 "b81255394e3ea8e8aa887276d22afa8985fc8daef60692eb2407d23049f03cfb"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://cairographics.org/releases/?C=M&O=D"
    regex(/href=.*?cairomm[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:    "f0343ad4ea24ef24041422413d36b5a8aae65628dd5d756c94114d22e09709ad"
    sha256 cellar: :any, arm64_sequoia:  "0a9512445631806965c6983c9081ca3502d04ae9d2ca70760152a5ea5add5ce6"
    sha256 cellar: :any, arm64_sonoma:   "9da9227f04ce5e2dfd54e6d1e39ce19ccb9edb062acf7751105c45174d971824"
    sha256 cellar: :any, arm64_ventura:  "b335188e992781cf00c6157bc3672aeb97462de721113c605a81f73b25a3188b"
    sha256 cellar: :any, arm64_monterey: "badd15644a940fcdb2fbe0ad21e9c24073098a421dd6bc705ea4cf6bd9cd4699"
    sha256 cellar: :any, sonoma:         "0e38e709e43a068694a9a36c743930e133e0c1da6647de9ea82391e7a82052c9"
    sha256 cellar: :any, ventura:        "61f902ee74afad872595fa8664f5a3a7d702df38ab5299b445cf82d258e08d45"
    sha256 cellar: :any, monterey:       "f94ec9449571497fdf24911966394002d0d67c26081e21d7c5e471109a78e3f4"
    sha256               arm64_linux:    "3b866bb4f2e4ba2bf7772bd89e40e540473f7787f90bc0504991b80b5e578455"
    sha256               x86_64_linux:   "a7f537f71f9176e26a94e7b5db2a30f0ea266085486ca78af8e957e401d7de63"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "cairo"
  depends_on "libpng"
  depends_on "libsigc++"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <cairomm/cairomm.h>

      int main(int argc, char *argv[])
      {
         Cairo::RefPtr<Cairo::ImageSurface> surface = Cairo::ImageSurface::create(Cairo::Surface::Format::ARGB32, 600, 400);
         Cairo::RefPtr<Cairo::Context> cr = Cairo::Context::create(surface);
         return 0;
      }
    CPP

    pkg_config_cflags = shell_output("pkg-config --cflags --libs cairo cairomm-1.16").chomp.split
    system ENV.cxx, "-std=c++17", "test.cpp", *pkg_config_cflags, "-o", "test"
    system "./test"
  end
end
