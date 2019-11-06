class Libexif < Formula
  desc "EXIF parsing library"
  homepage "https://libexif.github.io/"
  url "https://downloads.sourceforge.net/project/libexif/libexif/0.6.21/libexif-0.6.21.tar.gz"
  sha256 "edb7eb13664cf950a6edd132b75e99afe61c5effe2f16494e6d27bc404b287bf"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a7d7a67f11d7ef89666e589ec589cae59bfe7aa6502f5e4449ee518b124fcf47" => :catalina
    sha256 "f2825b7f043b7e1128a8a234132622041669d6fd0b537c22dc0d06284a96c095" => :mojave
    sha256 "c12c945c59d694f82b43e82a62eebec5e968d57746de8d017f251a2e857db750" => :high_sierra
    sha256 "2d8c0924448d966dcbb963ab8e67ee0c24bfaa1ff45d77a2e7f6a705e547ee4f" => :sierra
    sha256 "5990278735f835e2ab004ceac83616a3a71f6ae96c6f5eb0c0f1aa2af0452fb6" => :el_capitan
    sha256 "cebb385c6f48fafa10b8731daec8ce38d8ee34ff7d3afc131edd553a2249662f" => :yosemite
    sha256 "791e4c2073051f5e93fee0f30d1888f39b2873eacbfadbc4b3dd6328b80dfb51" => :mavericks
  end

  def install
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
