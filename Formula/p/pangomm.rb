class Pangomm < Formula
  desc "C++ interface to Pango"
  homepage "https://www.gtk.org/docs/architecture/pango"
  url "https://download.gnome.org/sources/pangomm/2.58/pangomm-2.58.0.tar.xz"
  sha256 "217514c1a65035c2fce6e69e33b0d92bafa2594cc474e995a4473441b10f3a33"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4ed7a8fd20c2c4b23080fc8881e107499f3a51e3347c854a77ef3051a090e6e7"
    sha256 cellar: :any, arm64_tahoe:       "af63e35822fdec3f914dba2af313c621d34b0c2d123714c2a5408aed2caa571e"
    sha256 cellar: :any, arm64_sequoia:     "1ee24cf248414829a0bd416ca6774bd230f92c214470a36f061eb2bd707a06cf"
    sha256 cellar: :any, arm64_linux:       "f9da19ee46804e872edd1066cab040e1f85b42e0d9ae62a9c0ae39887bd57f34"
    sha256 cellar: :any, x86_64_linux:      "e15b8ad21c1571af43370a0243481d9dd73b0b8fab14b9d5b822441b39a885d1"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "cairomm"
  depends_on "glib"
  depends_on "glibmm"
  depends_on "libsigc++"
  depends_on "pango"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <pangomm.h>
      int main(int argc, char *argv[])
      {
        Pango::FontDescription fd;
        return 0;
      }
    CPP

    pkgconf_flags = shell_output("pkgconf --cflags --libs pangomm-2.48").chomp.split
    system ENV.cxx, "-std=c++17", "test.cpp", *pkgconf_flags, "-o", "test"
    system "./test"
  end
end
