class GtkMacIntegration < Formula
  desc "Integrates GTK macOS applications with the Mac desktop"
  homepage "https://wiki.gnome.org/Projects/GTK+/OSX/Integration"
  license "LGPL-2.1-only"
  revision 1

  stable do
    url "https://download.gnome.org/sources/gtk-mac-integration/3.0/gtk-mac-integration-3.0.1.tar.xz"
    sha256 "f19e35bc4534963127bbe629b9b3ccb9677ef012fc7f8e97fd5e890873ceb22d"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end

    # Avoid crash when non-UTF-8 locale is set:
    #   https://trac.macports.org/ticket/65474
    # Fix merged by upstream via:
    #   https://gitlab.gnome.org/GNOME/gtk-mac-integration/-/merge_requests/6
    patch do
      url "https://raw.githubusercontent.com/macports/macports-ports/a7f8a7049bb8e5c37a3a646bc216c5ab9244d9f6/devel/gtk-osx-application/files/patch-locale-gettext.diff"
      sha256 "af8a00c278110c4ad47b28b05e86d1a41531f764266d87d5cd843c416c7f7849"
      directory "src"
    end
  end

  # We use a common regex because gtk-mac-integration doesn't use GNOME's
  # "even-numbered minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/gtk-mac-integration[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "8717c04c7659cff47328719a99ad71d0aba5ad1dcd51b765a312a97601a411d4"
    sha256 arm64_ventura:  "1fc1129b7d43614e952bf740b905973eea3bdebfd2b3ca3f90421385a2e4464c"
    sha256 arm64_monterey: "5fdb5ed12f5c58671b00a3c6075a72699f2329661416bc9ebb8a50843194bf96"
    sha256 sonoma:         "ce2daefc2505d48d115c0731459c682892e6a157e0e5491af39ee3a8898361aa"
    sha256 ventura:        "aad2d1bfb099a2b052d66d5c0b888ca00a55e657b7ba19d3485dd753a540cd5b"
    sha256 monterey:       "342ebfd16e77e24285385a29d594b3cb28e750c19d9db8d4f4ee667181773c31"
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
