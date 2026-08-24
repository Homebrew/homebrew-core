class GlibmmAT266 < Formula
  desc "C++ interface to glib"
  homepage "https://gtkmm.gnome.org/"
  url "https://download.gnome.org/sources/glibmm/2.66/glibmm-2.66.10.tar.xz"
  sha256 "2b61780203aed98e701d3ea57c8f353e7c8ada9706a79be782f6c5153dd035c0"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.gnome.org/sources/glibmm/2.66/"
    regex(/href=.*?glibmm[._-]v?(2\.66(?:\.\d+)+)\.t/i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "86740d6dfb2323e1581a96e81a8d5ca0e9d90304e205efe9ea8d6e698d203314"
    sha256 cellar: :any, arm64_sequoia: "bce012b3a12e40f864a36c45d90cf6adbc6c344855c8d62cd7b49f2394a0be01"
    sha256 cellar: :any, arm64_sonoma:  "fe0d6c585d84e7fb5e3953fba3a03b69a949af81261d7b6370c410235f1cb11a"
    sha256 cellar: :any, sonoma:        "ccadfbceda2c029d7ed9dd6b8e623b2c9a2cc6d18fde9240059b444278c3b0ec"
    sha256               arm64_linux:   "64f9176e60b0055149f76946c91b4b2bdea8c77424835806d769a373a68daede"
    sha256               x86_64_linux:  "30e40aa643a9b494331eba01176b710361ad4479434b9aa56ff2ba4c04478648"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "glib"
  depends_on "libsigc++@2"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <glibmm.h>

      int main(int argc, char *argv[])
      {
         Glib::ustring my_string("testing");
         return 0;
      }
    CPP

    flags = shell_output("pkgconf --cflags --libs glibmm-2.4").chomp.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
