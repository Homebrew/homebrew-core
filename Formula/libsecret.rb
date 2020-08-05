class Libsecret < Formula
  desc "Library for storing/retrieving passwords and other secrets"
  homepage "https://wiki.gnome.org/Projects/Libsecret"
  url "https://download.gnome.org/sources/libsecret/0.20/libsecret-0.20.3.tar.xz"
  sha256 "4fcb3c56f8ac4ab9c75b66901fb0104ec7f22aa9a012315a14c0d6dffa5290e4"

  bottle do
    sha256 "6b63c9ade94d5428c76332662178a0ea47ea682478cc2a0d189acb5d9480b562" => :catalina
    sha256 "cf7e3aee821a63ef75f9ad9d33061d6dbd358b1bb07873d991f4b4e877842fef" => :mojave
    sha256 "d88253d0c70ec7cf66c6f7d4f3b2894d0cd68cfd381dbd3087860bdbeddde945" => :high_sierra
  end

  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
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
