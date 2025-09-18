class CairommAT114 < Formula
  desc "Vector graphics library with cross-device output support"
  homepage "https://cairographics.org/cairomm/"
  url "https://cairographics.org/releases/cairomm-1.14.5.tar.xz"
  sha256 "70136203540c884e89ce1c9edfb6369b9953937f6cd596d97c78c9758a5d48db"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://cairographics.org/releases/?C=M&O=D"
    regex(/href=.*?cairomm[._-]v?(1\.14(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:    "3c84812ac04258b3fe766341479b99b1e28a9572b995e7bd33e3184fdb29055a"
    sha256 cellar: :any, arm64_sequoia:  "87bd872e7129feb2db9ca965fe5e065ebef30f6a196f0c80d8012b60cef66bf2"
    sha256 cellar: :any, arm64_sonoma:   "cf8e7aa143ab206a8986997621217fc40e219d23a88e09d5a3d1ee1ce58d78c2"
    sha256 cellar: :any, arm64_ventura:  "76dbfad402d8573c6acfdbbf785ce70eb13e626318aa0c8f241864b43a8c8ee2"
    sha256 cellar: :any, arm64_monterey: "bd41c2293acda52bcef8fa7332b90860007ecb37b864677f59d624f1fff457df"
    sha256 cellar: :any, sonoma:         "48cd095943b2001726bd9b8f678424725e73c3ac4d088e61cff65b973641ae0c"
    sha256 cellar: :any, ventura:        "a642e54afb60394f1dc138b3611b0c729f09d9aa0217a351823b1ae75816bcf2"
    sha256 cellar: :any, monterey:       "4ef3f6806bae703ef82e302f33c28d96136d3bbbdef56c36f9032cf6aaa10c46"
    sha256               arm64_linux:    "d23cd3b782f7fbaa3bdf7445334de4f170ab6349feefc443e3362944515a0190"
    sha256               x86_64_linux:   "4fce5fb84ea0095ce2f9e0996c926fc8bb54f55a458a9eb1be50a40241f8a6e5"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "cairo"
  depends_on "libpng"
  depends_on "libsigc++@2"

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
         Cairo::RefPtr<Cairo::ImageSurface> surface = Cairo::ImageSurface::create(Cairo::FORMAT_ARGB32, 600, 400);
         Cairo::RefPtr<Cairo::Context> cr = Cairo::Context::create(surface);
         return 0;
      }
    CPP

    pkg_config_cflags = shell_output("pkg-config --cflags --libs cairo cairomm-1.0").chomp.split
    system ENV.cxx, "-std=c++11", "test.cpp", *pkg_config_cflags, "-o", "test"
    system "./test"
  end
end
