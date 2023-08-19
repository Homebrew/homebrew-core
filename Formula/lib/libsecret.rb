class Libsecret < Formula
  desc "Library for storing/retrieving passwords and other secrets"
  homepage "https://wiki.gnome.org/Projects/Libsecret"
  url "https://download.gnome.org/sources/libsecret/0.20/libsecret-0.20.5.tar.xz"
  sha256 "3fb3ce340fcd7db54d87c893e69bfc2b1f6e4d4b279065ffe66dac9f0fd12b4d"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "14d4b00645910a57f3949dd8506e0df60b00ed4e8892ff08ec16a0cd42dd7709"
    sha256 cellar: :any, arm64_monterey: "38a274dc11d584dac3a265339c366a8222bf51d81142c65908164391cae6b789"
    sha256 cellar: :any, arm64_big_sur:  "23de21c66b4f88d01394e21e1827996b1660efdd8250f49fdbca528918cddfd9"
    sha256 cellar: :any, ventura:        "f41d2e6bf402050600fcc4c9d6211ef48829ba7564a89256928e65c44fb486f4"
    sha256 cellar: :any, monterey:       "52e590836bb88b9a3d1ce3f29dd2e9c0d5f5812fceab2832228d8bff36b4c661"
    sha256 cellar: :any, big_sur:        "c1049f62e574ca71381f1f094d91acc44f98ad92876de2d8393099a46c73d969"
    sha256 cellar: :any, catalina:       "2c4f4cd18a9563c27effbe7fbc28d5831751c2b5e5db7509ace428dab8f1398f"
    sha256               x86_64_linux:   "1c058afaabea66bc915fc2f412f4f64d84a4b28c0243e5036544b76e884a64f3"
  end

  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "libgcrypt"
  uses_from_macos "libxslt" => :build

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    mkdir "build" do
      system "meson", "..", "-Dbashcompdir=#{bash_completion}",
                            "-Dgtk_doc=false",
                            *std_meson_args
      system "ninja", "--verbose"
      system "ninja", "install", "--verbose"
    end
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
