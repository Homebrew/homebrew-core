class GtkMacIntegration < Formula
  desc "Integrates GTK macOS applications with the Mac desktop"
  homepage "https://wiki.gnome.org/Projects/GTK+/OSX/Integration"
  license "LGPL-2.1-only"

  stable do
    url "https://download.gnome.org/sources/gtk-mac-integration/3.0/gtk-mac-integration-3.0.1.tar.xz"
    sha256 "f19e35bc4534963127bbe629b9b3ccb9677ef012fc7f8e97fd5e890873ceb22d"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  # We use a common regex because gtk-mac-integration doesn't use GNOME's
  # "even-numbered minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/gtk-mac-integration[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "41bcc5495f77b99f80a3cbe97fb744b43e5141249d226c6d3da222f7f1eb3e25"
    sha256 arm64_monterey: "dab3cf5758414f811f6921ba8cd60df24fdd3c93df1c4b3d582e57a0fe27aeb7"
    sha256 arm64_big_sur:  "f3ab908832ae236c157fcb29c6178a7d0ce0c521990be382270fcb0233351774"
    sha256 ventura:        "c45af5d6a0da2f60200fcab09074b65159d1ab5f73abbddab698bbb1b3c6e04b"
    sha256 monterey:       "fe06a5ac783e080a93d5b99c11ac607f9b35a607aa670aaf7afd0918270c093c"
    sha256 big_sur:        "11cd268c22f0c1e52774fbc4368d953915cf58d0a212719e01dd721f17c89162"
    sha256 catalina:       "0c2b66f0715a364905ae8d61e1edd06dad96efc0ad72efa90dbdd756397468e0"
    sha256 mojave:         "a6b21fe6cda9fd1a06aacd818ac646380e878969f95a6964729f950371e68255"
  end

  head do
    url "https://gitlab.gnome.org/GNOME/gtk-mac-integration.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "gettext"
  depends_on "gtk+3"
  depends_on :macos

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, *std_configure_args,
                      "--disable-silent-rules",
                      "--without-gtk2",
                      "--with-gtk3",
                      "--enable-introspection=yes",
                      "--enable-python=no"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtkosxapplication.h>

      int main(int argc, char *argv[]) {
        gchar *bundle = gtkosx_application_get_bundle_path();
        return 0;
      }
    EOS
    flags = shell_output("pkg-config --cflags --libs gtk-mac-integration-gtk3").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
