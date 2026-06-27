class PangommAT246 < Formula
  desc "C++ interface to Pango"
  homepage "https://www.gtk.org/docs/architecture/pango"
  url "https://download.gnome.org/sources/pangomm/2.46/pangomm-2.46.5.tar.xz"
  sha256 "38ca0b050b065de4e3da0c182df657437757063bbf0c4b6c9567ddba019b1d68"
  license "LGPL-2.1-only"

  livecheck do
    url :stable
    regex(/pangomm-(2\.46(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b65a2cf3ead9ed8c5aeb1d91ac43fb1ee204d554d9d35aa0295d4a5bad17cc27"
    sha256 cellar: :any, arm64_sequoia: "7237ca0532ff36e67b2bd882cc4dcb5dd5b3daa86fd33764295b557c40ee1828"
    sha256 cellar: :any, arm64_sonoma:  "d1ad5d059163fc285bc1c9be2a98bca3e3474a2e26e19febed16bdbef6f6600d"
    sha256 cellar: :any, sonoma:        "dee92f8cbb8b553307504ed88fe7234b122db575e7cb0eae09a0b2dfe0918b9e"
    sha256               arm64_linux:   "55247160eaf3c67fbf5300c3dabc20b03487f679aa787966938bd544d1e26111"
    sha256               x86_64_linux:  "55d97cd5b3cb3e3545e40c212ca896f6a3af724b0119b402a6027256b395c8f1"
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
