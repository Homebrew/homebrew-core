class Libgsf < Formula
  desc "I/O abstraction library for dealing with structured file formats"
  homepage "https://gitlab.gnome.org/GNOME/libgsf"
  url "https://download.gnome.org/sources/libgsf/1.14/libgsf-1.14.53.tar.xz"
  sha256 "0eb59a86e0c50f97ac9cfe4d8cc1969f623f2ae8c5296f2414571ff0a9e8bcba"
  license "LGPL-2.1-only"
  revision 1

  bottle do
    sha256 arm64_tahoe:   "c9198abd992dd04f3aae0030ac3e67af9e4a4096f906eb5a3f8681f33da18a7c"
    sha256 arm64_sequoia: "31487301757276c2c88e9779b5bb16eb1226083f6fb9802a32a5b38d7ae6097c"
    sha256 arm64_sonoma:  "d2f7817329833dcf7a03ece697c54e790c89e08e14d4d219a803f84afca8b233"
    sha256 sonoma:        "4ecaea80f6ba17910c339baa96083b0b32daf7ad09cc8c52d83113c5b3925c2d"
    sha256 arm64_linux:   "18e121cdc81bbf665f9b0a7dcbd40c9efe95d1620d6b75fe877772b733ba08e3"
    sha256 x86_64_linux:  "98870890380476e5dad8a0e74852fb44d7b8bdd16c1d42aebe089dcde4b067d2"
  end

  head do
    url "https://github.com/GNOME/libgsf.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "glib"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"gsf", "--help"
    (testpath/"test.c").write <<~C
      #include <gsf/gsf-utils.h>
      int main()
      {
          void
          gsf_init (void);
          return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test",
           "-I#{include}/libgsf-1",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include"
    system "./test"
  end
end
