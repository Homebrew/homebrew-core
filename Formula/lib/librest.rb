class Librest < Formula
  desc "Library to access RESTful web services"
  homepage "https://wiki.gnome.org/Projects/Librest"
  url "https://download.gnome.org/sources/rest/0.9/rest-0.9.1.tar.xz"
  sha256 "9266a5c10ece383e193dfb7ffb07b509cc1f51521ab8dad76af96ed14212c2e3"
  license all_of: ["LGPL-2.1-or-later", "LGPL-3.0-or-later"]
  revision 1

  # librest doesn't seem to follow the typical GNOME version scheme, so we
  # provide a regex to disable the `Gnome` strategy's version filtering.
  livecheck do
    url :stable
    regex(/rest[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e76bb42c804ee253aae0f581c72d121155c22180f6ce3917b1a94e4276086a46"
    sha256 cellar: :any, arm64_sequoia: "0a699a3e62f7035586853564492235d8778647d0cf348c2482708e17c4690c0e"
    sha256 cellar: :any, arm64_sonoma:  "aac6f3ab8292924de0a5838b47151ce4cf1bcb083b71e49e3714507c90cb44dc"
    sha256 cellar: :any, sonoma:        "53cca284053a914c5343fa07e98cee02aa01c5e02ca69974b0c71d7002dda40b"
    sha256               arm64_linux:   "c4abc96ee37a45a227101d5345a9ecfc753860b6b77283fc20fc848b4757ab9f"
    sha256               x86_64_linux:  "fed14fb30d8f8a379de83f08fd4ea0ef9ef4b6d194e8da469d9ba4acbda524f8"
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
