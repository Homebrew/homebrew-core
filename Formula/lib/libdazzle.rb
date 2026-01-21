class Libdazzle < Formula
  desc "GNOME companion library to GObject and Gtk+"
  homepage "https://gitlab.gnome.org/GNOME/libdazzle"
  url "https://download.gnome.org/sources/libdazzle/3.44/libdazzle-3.44.0.tar.xz"
  sha256 "3cd3e45eb6e2680cb05d52e1e80dd8f9d59d4765212f0e28f78e6c1783d18eae"
  license "GPL-3.0-or-later"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "c85ea978999366c90f0a82d06f658d48a09ed3e021cd7edaedc8d18140145b77"
    sha256 arm64_sequoia:  "87f5700425b73e8a64c2b6af4f2f1ee74028b1921d147ba239a298c10ea12b05"
    sha256 arm64_sonoma:   "f79987d1cba7d798fe6cb2c824439ddb41dbac57df64c75dc8cf72e66a9c0d25"
    sha256 arm64_ventura:  "e08d05fceceacb8f02483c79711d7320d9d1888c2307cfb1b65b9a1524f27722"
    sha256 arm64_monterey: "a3553a76ef15ac7c2268e9ce059d1321c44b8d7fbdf13013f08b8d5f5d23de23"
    sha256 sonoma:         "2fca358ca672c44ed32595ce7769e77d777e3c62073ed4c445210614d030280a"
    sha256 ventura:        "2e8a40dcec28ed8a7cdae08bb4d1c1844b9d0dfff1c2da917d75e9259b42cff7"
    sha256 monterey:       "648477570e7a597bc703e6cfa2ee418aba691ec253e7f40c79c33b3b2e95b8b9"
    sha256 arm64_linux:    "6f85bbfc14f0f732331e2e93c24df2ebd97bf9e3356189f4eb6777735d411a15"
    sha256 x86_64_linux:   "7a8395fdb2257d54ffc90ebcb1a95796c87fba132b602c14ed0c42e384bb90e8"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "pango"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  def install
    system "meson", "setup", "build", "-Dwith_vapi=true", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <dazzle.h>

      int main(int argc, char *argv[]) {
        g_assert_false(dzl_file_manager_show(NULL, NULL));
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs libdazzle-1.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
