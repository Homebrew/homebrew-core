class Libexif < Formula
  desc "EXIF parsing library"
  homepage "https://libexif.github.io/"
  url "https://github.com/libexif/libexif/releases/download/v0.6.23/libexif-0.6.23.tar.xz"
  sha256 "a740a99920eb81ae0aa802bb46e683ce6e0cde061c210f5d5bde5b8572380431"
  license "LGPL-2.1"

  bottle do
    sha256 arm64_monterey: "07f9ad919f5bdbb2857580549cba37da0aee5c1fb88cd5eb410ac3ec857de11d"
    sha256 arm64_big_sur:  "f2a133f663a82d1d39ba238692f6c56de3c6bae12add2107204a75af2f6d923a"
    sha256 monterey:       "8765b62cdc2dd20a77ed83f8e4acdfbfea0cb1ad55a53b40372c912a796aa13d"
    sha256 big_sur:        "17a348763e827089c2d2fb2b2c631f38df87d99234d81f2bbbe1c7219577522c"
    sha256 catalina:       "5b2a8266f5236b9fe1921040976c07d9eda3cc178a2c2d82824254de82df0e2e"
    sha256 mojave:         "85e039d08a8668365cd7f71a9012c587028e4e6d6dfe0a9cc082bcc99ca7b643"
    sha256 x86_64_linux:   "6b20530c09fffe2d4dcda90dfd9b8c1869e1ff58fe94eb9e74763d2f705f1a9e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gettext"

  def install
    system "autoreconf", "-ivf"
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <libexif/exif-loader.h>

      int main(int argc, char **argv) {
        ExifLoader *loader = exif_loader_new();
        ExifData *data;
        if (loader) {
          exif_loader_write_file(loader, argv[1]);
          data = exif_loader_get_data(loader);
          printf(data ? "Exif data loaded" : "No Exif data");
        }
      }
    EOS
    flags = %W[
      -I#{include}
      -L#{lib}
      -lexif
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    test_image = test_fixtures("test.jpg")
    assert_equal "No Exif data", shell_output("./test #{test_image}")
  end
end
