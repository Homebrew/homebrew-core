class Libgee < Formula
  desc "Collection library providing GObject-based interfaces"
  homepage "https://wiki.gnome.org/Projects/Libgee"
  url "https://download.gnome.org/sources/libgee/0.20/libgee-0.20.8.tar.xz"
  sha256 "189815ac143d89867193b0c52b7dc31f3aa108a15f04d6b5dca2b6adfad0b0ee"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f2b5d2af9aaf72eca39ea04074d26eae49e96fcf2d43e38f659cfd5115443a55"
    sha256 cellar: :any,                 arm64_sequoia: "f6f8a615e12ebbf0e2d1ef652b9d6118ce7090cf975e76c9199b80f2d54a0ee2"
    sha256 cellar: :any,                 arm64_sonoma:  "a74893c386bc3c98b3eca70f4698eac4fc16a7c7ce9621ecd9951881b52617b2"
    sha256 cellar: :any,                 arm64_ventura: "9f59442b282ad4bc6857568f22fc866f04111dfa83f52a36fdff920b72404efd"
    sha256 cellar: :any,                 sonoma:        "54b304a5bb1c6cd0b4cf4ad92e33497616250375a1d199b056f712059484c8f8"
    sha256 cellar: :any,                 ventura:       "18ef7dfdbad016c9f6027374cb705a7e2195204d524cc42439d98855e24837f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3a4b234964285662e7ae86aba11035910b5b435c74d1d86755b53d803e2ef15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "695ca3b94a6452ef5d365da12bcf3b9b12a3e80c298f5c6d032bd873926a9ef4"
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "glib"

  on_macos do
    depends_on "gettext"
  end

  def install
    # ensures that the gobject-introspection files remain within the keg
    inreplace "gee/Makefile.in" do |s|
      s.gsub! "@HAVE_INTROSPECTION_TRUE@girdir = @INTROSPECTION_GIRDIR@",
              "@HAVE_INTROSPECTION_TRUE@girdir = $(datadir)/gir-1.0"
      s.gsub! "@HAVE_INTROSPECTION_TRUE@typelibdir = @INTROSPECTION_TYPELIBDIR@",
              "@HAVE_INTROSPECTION_TRUE@typelibdir = $(libdir)/girepository-1.0"
    end

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gee.h>

      int main(int argc, char *argv[]) {
        GType type = gee_traversable_stream_get_type();
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs gee-0.8").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
