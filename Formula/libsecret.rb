class Libsecret < Formula
  desc "Library for storing/retrieving passwords and other secrets"
  homepage "https://wiki.gnome.org/Projects/Libsecret"
  url "https://download.gnome.org/sources/libsecret/0.18/libsecret-0.18.6.tar.xz"
  sha256 "5efbc890ba41a323ffe0599cd260fd12bd8eb62a04aa1bd1b2762575d253d66f"
  revision 1

  bottle do
    sha256 "716ae8c743ec4c3224178708663b404572386a8f416023b8f729e5256ed4db17" => :mojave
    sha256 "6a4ab070179363f9468424a354267afc31c61d6c50fca9f082ec4bae96d69769" => :high_sierra
    sha256 "600584d69e9688bdcecb510b7e10d1fab9593e789ce72a27c57a7da8cfb54488" => :sierra
    sha256 "9d64c0daf3b3f02d44eb2e24d156a76526afa0d00b6b911a5aecdfa8ccfd81b4" => :el_capitan
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
