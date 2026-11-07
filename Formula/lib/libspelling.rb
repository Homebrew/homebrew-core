class Libspelling < Formula
  desc "Spellcheck library for GTK 4"
  homepage "https://gitlab.gnome.org/GNOME/libspelling"
  url "https://gitlab.gnome.org/GNOME/libspelling/-/archive/0.4.11/libspelling-0.4.11.tar.bz2"
  sha256 "304ff82faaeb0ba131765a819f2db8ba5655bdbadc78fea64c12033274acebec"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256               arm64_golden_gate: "b7eea5b77dd069c25fee933c36d061f411ec41a7e0c607c9def5e95c09e71e71"
    sha256               arm64_tahoe:       "f16e238a9d129c0a343b9ef2ec24bb6b317257355ae7a48fab3248c52bf673b8"
    sha256               arm64_sequoia:     "291ef77d7b7133dee4afcb5e66c72157b4e62345e5f47fba1ce0f896d5e5b462"
    sha256 cellar: :any, arm64_linux:       "7f387bf9183fbf64e84077207b7b79d30ac89fc6a1a195409b3f1e6a5eafd725"
    sha256 cellar: :any, x86_64_linux:      "fc89779d454e77b4534bcf7b611b19dda54fe36e2d50e3ebcc6c902a3f90285d"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "enchant"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "gtksourceview5"
  depends_on "icu4c@79"
  depends_on "pango"

  on_macos do
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "gettext"
    depends_on "graphene"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "sysprof"
  end

  def install
    system "meson", "setup", "build", "-Ddocs=false", "-Dsysprof=#{OS.linux?}", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libspelling.h>

      int main(int argc, char *argv[]) {
        SpellingChecker *checker = spelling_checker_get_default();
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs libspelling-1").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
