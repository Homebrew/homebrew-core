class CairommAT114 < Formula
  desc "Vector graphics library with cross-device output support"
  homepage "https://cairographics.org/cairomm/"
  url "https://cairographics.org/releases/cairomm-1.14.6.tar.xz"
  sha256 "7e0d5c7f29175d573a03ab5c45aef63f48dd91a5caf335a404cd763e4b7cea4a"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://cairographics.org/releases/?C=M&O=D"
    regex(/href=.*?cairomm[._-]v?(1\.14(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6657f08fd9b8775951f39f9c97a1cc917e3ae77e9bd4a4aa9df3ca55cfade320"
    sha256 cellar: :any, arm64_sequoia: "e33f2d072d63f550e21c87789221905a84f4d9437719edf3120723dd63dc7a3f"
    sha256 cellar: :any, arm64_sonoma:  "ef5168a5a841031385526072af775570265b9647617682b4e61cdbc3e0c4ee94"
    sha256 cellar: :any, sonoma:        "bf98c509c631f27d850fd822af7027f02acbc08ddf56cfd30d741bfc29f96e3c"
    sha256               arm64_linux:   "d2784e171727d5b1848c9bbd02fdc3f023f3b682f62c0b9356f7a4a3ee177ecb"
    sha256               x86_64_linux:  "bc2b29bfdd4694ce73af6df152c134d9d6b289ba801de6580ed7b430038e8e54"
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
