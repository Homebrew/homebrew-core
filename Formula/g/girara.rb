class Girara < Formula
  desc "GTK+3-based user interface library"
  homepage "https://pwmt.org/projects/girara/"
  url "https://pwmt.org/projects/girara/download/girara-0.4.5.tar.xz"
  sha256 "6b7f7993f82796854d5036572b879ffaaf7e0b619d12abdb318ce14757bdda91"
  license "Zlib"

  livecheck do
    url "https://pwmt.org/projects/girara/download/"
    regex(/girara[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "a1acae5cff148bce38ed23cf7d703ea25b10d8a2fd5d2de2aca60b6015b56571"
    sha256 arm64_sequoia: "be06762224f503f78a683cce58ebb79c29b1debe98b6b6c65100119ffb559444"
    sha256 arm64_sonoma:  "c59225a3fb9db2fdfaf89c19a755bd7d4426a659a83db5330820835b37597bdc"
    sha256 arm64_ventura: "388b59083580d34bf7de60f3ef3bdf77dfb8eb4902f9b61084ab15c7a2b599e7"
    sha256 sonoma:        "858bea2192e09d07c39586ffbcb5fad2d8fb2999ed89ef12c32fd0842d7e0c76"
    sha256 ventura:       "a5effb75f802f10a8ce1c5f48d79183119ce88f8110ff3276f29d9cd557e8e00"
    sha256 arm64_linux:   "dee7dab31b8be5b1846d89d94362dee0c4f9f7510db1054658184ff87ef6e4ed"
    sha256 x86_64_linux:  "3c368c1cf542567633f37aabdd1d7e2ff1c745c9885d8bbe827cbc0fab1404e9"
  end

  depends_on "doxygen" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "glib"
  depends_on "gtk+3"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    (doc/"html").install Dir["build/doc/html/*"]
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>

      #include <girara/girara.h>

      int main(int argc, char** argv) {
        gtk_init(&argc, &argv);

        /* create girara session */
        girara_session_t* session = girara_session_create();

        if (session == NULL) {
          return -1;
        }

        if (girara_session_init(session, NULL) == false) {
          girara_session_destroy(session);
          return -1;
        }

        girara_session_destroy(session);

        return 0;
      }
    C
    pkg_config_flags = shell_output("pkg-config --cflags --libs girara-gtk3").chomp.split
    system ENV.cc, "test.c", *pkg_config_flags, "-o", "test"

    # Gtk-WARNING **: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "./test"
  end
end
