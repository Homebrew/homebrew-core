class Libsecret < Formula
  desc "Library for storing/retrieving passwords and other secrets"
  homepage "https://wiki.gnome.org/Projects/Libsecret"
  url "https://download.gnome.org/sources/libsecret/0.18/libsecret-0.18.6.tar.xz"
  sha256 "5efbc890ba41a323ffe0599cd260fd12bd8eb62a04aa1bd1b2762575d253d66f"
  revision 1

  bottle do
    sha256 "583473cf026c29c42884e9b14339bdec9f6b4eb447e0cdbb14761dda998a9489" => :mojave
    sha256 "a8326840251e2661e1c598a268a418dd62f382f8e2c60718581c71441e3740d8" => :high_sierra
    sha256 "0466f97c31fc994382b8944c0ad1b72b55d09b82d2584996bfe801a6bc0c5109" => :sierra
  end

  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "gnu-sed" => :build
  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "libgcrypt"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-introspection
      --enable-vala
    ]

    system "./configure", *args

    # https://bugzilla.gnome.org/show_bug.cgi?id=734630
    inreplace "Makefile", "sed", "gsed"

    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libsecret/secret.h>

      const SecretSchema * example_get_schema (void) G_GNUC_CONST;

      const SecretSchema *
      example_get_schema (void)
      {
          static const SecretSchema the_schema = {
              "org.example.Password", SECRET_SCHEMA_NONE,
              {
                  {  "number", SECRET_SCHEMA_ATTRIBUTE_INTEGER },
                  {  "string", SECRET_SCHEMA_ATTRIBUTE_STRING },
                  {  "even", SECRET_SCHEMA_ATTRIBUTE_BOOLEAN },
                  {  "NULL", 0 },
              }
          };
          return &the_schema;
      }

      int main()
      {
          example_get_schema();
          return 0;
      }
    EOS

    flags = [
      "-I#{include}/libsecret-1",
      "-I#{HOMEBREW_PREFIX}/include/glib-2.0",
      "-I#{HOMEBREW_PREFIX}/lib/glib-2.0/include",
    ]

    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
