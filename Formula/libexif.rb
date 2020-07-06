class Libexif < Formula
  desc "EXIF parsing library"
  homepage "https://libexif.github.io/"
  url "https://github.com/libexif/libexif/releases/download/libexif-0_6_22-release/libexif-0.6.22.tar.xz"
  sha256 "5048f1c8fc509cc636c2f97f4b40c293338b6041a5652082d5ee2cf54b530c56"
  license "LGPL-2.1"

  bottle do
    sha256 "7379f6990018006122bba69098864e8877e8e6e7be3af535f7e301d8ff097e98" => :catalina
    sha256 "c20d311fbd1846ce2603950ec9ad9b3b6e8202bf2f97e9aab328c05dc568fcfe" => :mojave
    sha256 "8b1c7cf6ec777090ce22ccf5c426867948a54da9378e0c9b91d85175eaea4f81" => :high_sierra
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
