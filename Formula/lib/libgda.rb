class Libgda < Formula
  desc "Provides unified data access to the GNOME project"
  homepage "https://www.gnome-db.org/"
  url "https://download.gnome.org/sources/libgda/6.0/libgda-6.0.0.tar.xz"
  sha256 "995f4b420e666da5c8bac9faf55e7aedbe3789c525d634720a53be3ccf27a670"
  # The executable tools are GPL-2.0-or-later, but these are considered experimental
  # and not installed by default. The license should be updated when tools are installed.
  license "LGPL-2.0-or-later"
  revision 4

  bottle do
    sha256 arm64_sequoia: "2be57dbae0d6ba2cb489b405aeed1d4b00f6dc4ce1182dce49aec0fd1093a813"
    sha256 arm64_sonoma:  "9cf877eaebc81fecfc1970b452f851b801f326d8154291d88fdbbad78cceecfd"
    sha256 arm64_ventura: "4c863bea61f7fe27324a05e1ecaeb3f5baf67a87ad8fc0cdb9dbec71102a44db"
    sha256 sonoma:        "6385eb68f99390c392e26c8798c20fac9f07c3a22ca4f7bb6550b2cac507c6fc"
    sha256 ventura:       "1753780cc82f8f481ebaed1f645416d8aea7586a020876cebe631485977799a4"
    sha256 arm64_linux:   "5fe8b7ec5d76567900e301e69b302f05a282fc2ead4063002502581bf6a1692e"
    sha256 x86_64_linux:  "2c0269be185ff06ae59bbd4eabf89b43b465a20c9282095ace9d4dd8ddb54762"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "iso-codes"
  depends_on "json-glib"
  depends_on "mariadb-connector-c"
  depends_on "sqlite"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  # Backport fix for sqlcipher and sqlite pkg-config file generation
  patch do
    url "https://gitlab.gnome.org/GNOME/libgda/-/commit/3e0c7583ddcc3649f24ad1f1b5d851072fd3f721.diff"
    sha256 "a6cb1927ef2174267fd5b01ca7d6b1141f4bad969fa6d10560c62998c6150fd4"
  end

  # Backport fix for undefined behavior due to signed integer overflow
  patch do
    url "https://gitlab.gnome.org/GNOME/libgda/-/commit/657b2f8497da907559a6769c5b1d2d7b5bd40688.diff"
    sha256 "bfc26217647e27aaf065a4b6c210b96e1a6f7cd67d780a3a124951c6a5bc566d"
  end

  # Backport fix for macOS dynamic loading of sqlite.dylib
  patch do
    url "https://gitlab.gnome.org/GNOME/libgda/-/commit/98f014c783583e3ad87ee546e8dccf34d50f1e37.diff"
    sha256 "2f2d257085b40ef4fccf2db68fe51407ba0f59d39672fc95fd91be3e46e91ffa"
  end

  # Apply Fedora patch to use `mariadb-connector-c`
  patch do
    url "https://src.fedoraproject.org/rpms/libgda/raw/e33ef2c0af32d1aab4a1255b83882552e36002a4/f/mariadb.patch"
    sha256 "5e2dca080ab2d5d09bba5d41ff4bc7dd63dea5f9f493d6b3e28d592ef48f52fc"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    pkgshare.install "examples/SimpleExample/example.c"
  end

  test do
    cp pkgshare/"example.c", testpath
    flags = shell_output("pkgconf --cflags --libs libgda-#{version.major_minor}").chomp.split
    system ENV.cc, "example.c", "-o", "example", *flags
    assert_match <<~EOS, shell_output("./example")
      ------+---------+---------
      p1    | chair   | 2.000000
      p3    | glass   | 1.100000
      p1000 | flowers | 1.990000
      (3 rows)
    EOS
  end
end
