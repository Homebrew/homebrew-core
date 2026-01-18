class Gtksourceviewmm3 < Formula
  desc "C++ bindings for gtksourceview3"
  homepage "https://gitlab.gnome.org/GNOME/gtksourceviewmm"
  url "https://download.gnome.org/sources/gtksourceviewmm/3.18/gtksourceviewmm-3.18.0.tar.xz"
  sha256 "51081ae3d37975dae33d3f6a40621d85cb68f4b36ae3835eec1513482aacfb39"
  license "LGPL-2.1-or-later"
  revision 11

  livecheck do
    url :stable
    regex(/gtksourceviewmm[._-]v?(3\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "9b6d8f50cc16f92feecf432734adc4837246ba8f3fdb933b126393f6137dadc1"
    sha256 cellar: :any,                 arm64_sequoia:  "8de9f30c9a139c912211e4766370c1b2a3b4f78150a4342f6242f56581ebf3bb"
    sha256 cellar: :any,                 arm64_sonoma:   "dc3f50e8c5d192b4dc176878e95f4b7bf28d0a19e21c7c47b88f1c5905f64ebb"
    sha256 cellar: :any,                 arm64_ventura:  "fa886fba1a65986e976859a1c9714b8892695850e6c8325dc534532f31536f0a"
    sha256 cellar: :any,                 arm64_monterey: "9353790d382f15315725c82eb60364f0533d2cc4d3e7483abbc34ab4962f3688"
    sha256 cellar: :any,                 sonoma:         "6d967d0889a430e64312a18afbae33554340938c8fae2a90ddd652cd2beb86cd"
    sha256 cellar: :any,                 ventura:        "599a63e233b2cab4497e4266780a1c4a55616aeb6a8dfbdb7fa92c0f443720c6"
    sha256 cellar: :any,                 monterey:       "e47d5fa75c9210450660bdd5bbb0ca206e90beba0a0954e49a7b7596e6bc5a42"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b71c353cdef6b20cb4b871ad1ec98712271fe7f123d793917ca5738cbe0ce099"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6489e67344895dad8ef93a694a47c49fec20dc0735989355b11489cd85fbccd"
  end

  depends_on "pkgconf" => [:build, :test]

  depends_on "atkmm@2.28"
  depends_on "cairomm@1.14"
  depends_on "glib"
  depends_on "glibmm@2.66"
  depends_on "gtk+3"
  depends_on "gtkmm3"
  depends_on "gtksourceview3"
  depends_on "libsigc++@2"
  depends_on "pangomm@2.46"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pango"
  end

  def install
    ENV.cxx11
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <gtksourceviewmm.h>

      int main(int argc, char *argv[]) {
        Gsv::init();
        return 0;
      }
    CPP

    flags = shell_output("pkgconf --cflags --libs gtksourceviewmm-3.0").chomp.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
