class Libsecret < Formula
  desc "Library for storing/retrieving passwords and other secrets"
  homepage "https://wiki.gnome.org/Projects/Libsecret"
  url "https://download.gnome.org/sources/libsecret/0.20/libsecret-0.20.2.tar.xz"
  sha256 "81e9143833785cdcf96c1da5d0357a8bcf0cd2b0119f15aa0cae775d1f19ffc3"

  bottle do
    sha256 "d96a2e3697e1acc9b79ccc8adfa91f0a32fc4baec79563c7d93c8c80923379f3" => :catalina
    sha256 "1217381a3990dc19e98e060ff98ee68d900a7ebcfc3e1cc5a06963bf0833d1a0" => :mojave
    sha256 "f3c7f866f9dd26f56305d1111eacebc43c633bbbab641b661690c2c2ed8443a2" => :high_sierra
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
