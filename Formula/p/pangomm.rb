class Pangomm < Formula
  desc "C++ interface to Pango"
  homepage "https://www.gtk.org/docs/architecture/pango"
  url "https://download.gnome.org/sources/pangomm/2.56/pangomm-2.56.2.tar.xz"
  sha256 "f1e984c85a85b6a0e61616366521f51dd8282a072bb45d15b5084762b62f4c0e"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c50be3b577c1dd5329b742b97c51182af99225e4af2c7e9ae7a30c27f3f9e4f3"
    sha256 cellar: :any, arm64_sequoia: "66876cb88e4a97c28bfc160bbef33c2e87252a060f3b4bf21ef0c0f69290fc91"
    sha256 cellar: :any, arm64_sonoma:  "4a9fa4ed2f7cf7619f980ebe916e6f4d7267bcc07e5fa23881e95f68ec6ef012"
    sha256 cellar: :any, sonoma:        "2acbac325ad9deb034b28d161a3f6bdf43275e98de4fd9da11cdae42e332c9fe"
    sha256               arm64_linux:   "d02e8869da84ce1e9ac044a46af2f6532afb03a78570da1b8533b827d2c38771"
    sha256               x86_64_linux:  "6d53e3d4fff1001e35dc57f5ebfc19bfd5539aed55e74283d844270942c28ed9"
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
