class Gssdp < Formula
  desc "GUPnP library for resource discovery and announcement over SSDP"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gssdp/1.6/gssdp-1.6.3.tar.xz"
  sha256 "2fedb5afdb22cf14d5498a39a773ca89788a250fcf70118783df821e1f3f3446"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "97111b046784bdbc49f2216a33602e3a5081c79371e4c25388f99f82a7c9cff5"
    sha256 cellar: :any, arm64_sonoma:   "1883e3ff3aabb0e94c3655d0730c9ef57197e179882fce345968718d9d706b05"
    sha256 cellar: :any, arm64_ventura:  "6780845ffd82b7162e83933d15c02a40f14173c46c42aaa3048c78a368741173"
    sha256 cellar: :any, arm64_monterey: "90ce94882c16fabbcae645e03ac1f1e4653e05e71ff79847d4849ede89ec13d4"
    sha256 cellar: :any, sonoma:         "6d12bf3d48221158ae35d8f121ecf5a6ab1a255ce7cd8db2c212c99da44d4f17"
    sha256 cellar: :any, ventura:        "e26411028be8edf072f647c9c8dd4fb7929c2aea8aa46940d70c36bb26f71d21"
    sha256 cellar: :any, monterey:       "dc149d84e33f123c18e0a11858b16672f802bdef637d6f27322e310a23d7f237"
    sha256               x86_64_linux:   "1fdb4562ada9ffb0252f97fe765ce023d2530ff2528e4237cace63a29f75688a"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "libsoup"

  uses_from_macos "python" => :build

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV.prepend_path "XDG_DATA_DIRS", HOMEBREW_PREFIX/"share"

    system "meson", "setup", "build", "-Dsniffer=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libgssdp/gssdp.h>

      int main(int argc, char *argv[]) {
        GType type = gssdp_client_get_type();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/gssdp-#{version.major_minor}
      -D_REENTRANT
      -L#{lib}
      -lgssdp-#{version.major_minor}
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
