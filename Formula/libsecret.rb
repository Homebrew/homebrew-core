class Libsecret < Formula
  desc "Library for storing/retrieving passwords and other secrets"
  homepage "https://wiki.gnome.org/Projects/Libsecret"
  url "https://download.gnome.org/sources/libsecret/0.20/libsecret-0.20.4.tar.xz"
  sha256 "325a4c54db320c406711bf2b55e5cb5b6c29823426aa82596a907595abb39d28"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "115ff8e5af3b0bffd370a47d7165664dda193b4a2ac00e2054b455cbd77e6d6e"
    sha256 big_sur:       "68da058738e04fd8a7ec9713df527afec9dc8076a219548dc194184df337fe8a"
    sha256 catalina:      "8fc40fdf1fda5a1bd12661b96a1b0398cc0b600e9f43ef44384ffa82fa6b3133"
    sha256 mojave:        "80fa9108466d6fac5f752ce926a9f6175e4f701764d2b077a3cdee0109be8ba6"
    sha256 high_sierra:   "9663806ffb17b3c50eb015c43b2763ff47e12624e56d694d454f238748ea17e2"
    sha256 x86_64_linux:  "4dbbaa5c11684e272e180de703dfac9da1e3931fb51ab73067a7fd58b572c1d4"
  end

  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "libgcrypt"

  on_linux do
    depends_on "libxslt" => :build
  end

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
