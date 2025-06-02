class Librest < Formula
  desc "Library to access RESTful web services"
  homepage "https://wiki.gnome.org/Projects/Librest"
  url "https://download.gnome.org/sources/rest/0.9/rest-0.9.1.tar.xz"
  sha256 "9266a5c10ece383e193dfb7ffb07b509cc1f51521ab8dad76af96ed14212c2e3"
  license all_of: ["LGPL-2.1-or-later", "LGPL-3.0-or-later"]

  # librest doesn't seem to follow the typical GNOME version scheme, so we
  # provide a regex to disable the `Gnome` strategy's version filtering.
  livecheck do
    url :stable
    regex(/rest[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "06a5c8af4c882c1b19125a18709bb62b407e4b9ba38cc1cad2d7752cd589aead"
    sha256 cellar: :any, arm64_sonoma:  "35deb8d1d89dbdd0c7969023d92ef822175d1eaeb307033e7014ccf8bb100eed"
    sha256 cellar: :any, arm64_ventura: "c23e539c42b6212b8f58e04631f6b0603baa2974d6de31a2f39bec3e436c5d7b"
    sha256 cellar: :any, sonoma:        "0634c21e72f7232145f23bf36578835e0669d0d17db351491d57b8e15867aff3"
    sha256 cellar: :any, ventura:       "2b1dc70cd6eb900751e74bfbec6c61fb7ab603f75499717fa010403a591dd822"
    sha256               arm64_linux:   "7f0f5096f4313e89c82e2951eda636a0a3124427650f9b2c0cb6fdc9b1dc47b6"
    sha256               x86_64_linux:  "cc33d81a4b567bb31a1289239b806b9b312e66c47c83f1e3c8f0a7c6590d70ed"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "glib"
  depends_on "json-glib"
  depends_on "libsoup"

  uses_from_macos "libxml2"

  # Backport fix to avoid gnome-online-accounts crash
  patch do
    url "https://gitlab.gnome.org/GNOME/librest/-/commit/dc860c817c311f07b489cd00c6c8dea4ad1999ca.diff"
    sha256 "af856766a93efa65e8ac619ab2be1f974a6fdd522dc38296aaa76b0359dbad65"
  end

  def install
    system "meson", "setup", "build", "-Dexamples=false", "-Dgtk_doc=false", "-Dtests=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdlib.h>
      #include <rest/rest-proxy.h>

      int main(int argc, char *argv[]) {
        RestProxy *proxy = rest_proxy_new("http://localhost", FALSE);

        g_object_unref(proxy);

        return EXIT_SUCCESS;
      }
    C

    flags = shell_output("pkgconf --cflags --libs rest-1.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
