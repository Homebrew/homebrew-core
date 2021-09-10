class Gtksourceview5 < Formula
  desc "Text view with syntax, undo/redo, and text marks"
  homepage "https://projects.gnome.org/gtksourceview/"
  url "https://download.gnome.org/sources/gtksourceview/5.2/gtksourceview-5.2.0.tar.xz"
  sha256 "c9b34fa02654f56ce22fa08827d89db4ba81631b2e6d7d31ea65d13c729430e9"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtksourceview[._-]v?(5\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "0d1942117f008838775478880099e7947f4aa62a0edfc880deb7d75c23886003"
    sha256 big_sur:       "707dccdc76932f3cc415aa2023e11a2da4954802e6e7ff78e02f34ed5232244f"
    sha256 catalina:      "9de90cd3cfdd86fdb73fea825ee99e0d16ac2a3cd667eff86e8964a05bc33e56"
    sha256 mojave:        "ac9537f6f10d0240d6eda7d94a755c7e5a62a1009c27ea894d310dd9d1109d45"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "gtk4"
  depends_on "pcre2"

  def install
    args = std_meson_args + %w[
      -Dgir=true
      -Dvapi=true
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtksourceview/gtksource.h>

      int main(int argc, char *argv[]) {
        gchar *text = gtk_source_utils_unescape_search_text("hello world");
        return 0;
      }
    EOS
    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs gtksourceview-5").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
