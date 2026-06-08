class Cairomm < Formula
  desc "Vector graphics library with cross-device output support"
  homepage "https://cairographics.org/cairomm/"
  url "https://cairographics.org/releases/cairomm-1.18.1.tar.xz"
  sha256 "e0e996a979ee52c840dca3ee74f5d005e3259b94ddce58f255d3b6f47c8cb41d"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://cairographics.org/releases/?C=M&O=D"
    regex(/href=.*?cairomm[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "78d38524e50cf3e9e3157639a00c001d718a2f19a6886ad26c2e903c67c0e1cc"
    sha256 cellar: :any, arm64_sequoia: "517978852a99f9abf1440b4a701083935abf0d51ec0f9ddfa6f8f4ed0bc79856"
    sha256 cellar: :any, arm64_sonoma:  "e147e4e40aa2d209d6a528ee13edc76bd675c3fe40eafde9bd83e6e8d94f1503"
    sha256 cellar: :any, sonoma:        "8f4b4f9988a9b79405f12a33f6403b104b17304e0bc5e67e73e717623dab0b1f"
    sha256               arm64_linux:   "4b8b129df265f232212a786cc693e2804d71ae10c0615c92c8aeac138c9014fc"
    sha256               x86_64_linux:  "810eb790909a4bbbd7e8a84924dbb51ca86a2a514d44a60da851c16411f58149"
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
