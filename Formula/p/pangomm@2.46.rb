class PangommAT246 < Formula
  desc "C++ interface to Pango"
  homepage "https://www.gtk.org/docs/architecture/pango"
  url "https://download.gnome.org/sources/pangomm/2.46/pangomm-2.46.4.tar.xz"
  sha256 "b92016661526424de4b9377f1512f59781f41fb16c9c0267d6133ba1cd68db22"
  license "LGPL-2.1-only"

  livecheck do
    url :stable
    regex(/pangomm-(2\.46(?:\.\d+)*)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "59acdc333ff48dcaa839724326a109208097bf5395a4a6f932f094e2479f50f4"
    sha256 cellar: :any, arm64_sequoia: "c5c43ab69df3ee85326bb0abf15fd4057a46ce3900015be64abb8c8573d3202e"
    sha256 cellar: :any, arm64_sonoma:  "6468295dc13b7795464c8acbeb4d790c15b33e6431ff71401c05929cf2f9f3ff"
    sha256 cellar: :any, arm64_ventura: "b323db7914c80c804a6804b16cb58c8cb9a11d38ce52826b1cc469fa8dfd2510"
    sha256 cellar: :any, sonoma:        "ee486c1037b89986dec5c26f870d092f4510ba0e121dbb96525fab6a61d358f7"
    sha256 cellar: :any, ventura:       "1fc51b4f1d0ffde9fffb314a586bcf812fe84496c2a5c56f9fa362cfa91e9cf2"
    sha256               arm64_linux:   "83a7dc15c14d9031b26bb31705692823f7579ee94d962eb0e6e48952f7c50ba9"
    sha256               x86_64_linux:  "6b6a26c7bf0e1ba43a9a87dcf9c5b669da81070f282c6b26a70204207713bde3"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "cairomm@1.14"
  depends_on "glib"
  depends_on "glibmm@2.66"
  depends_on "libsigc++@2"
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

    pkgconf_flags = shell_output("pkgconf --cflags --libs pangomm-1.4").chomp.split
    system ENV.cxx, "-std=c++11", "test.cpp", *pkgconf_flags, "-o", "test"
    system "./test"
  end
end
