class Libexif < Formula
  desc "EXIF parsing library"
  homepage "https://libexif.github.io/"
  url "https://github.com/libexif/libexif/releases/download/v0.6.24/libexif-0.6.24.tar.bz2"
  sha256 "d47564c433b733d83b6704c70477e0a4067811d184ec565258ac563d8223f6ae"
  license "LGPL-2.1"

  bottle do
    sha256 arm64_monterey: "b71456dcf43a1697530075ed530dd4561e921de1ef9ac872ae173fb3c4b70596"
    sha256 arm64_big_sur:  "89e01320edd8d164b9a885c8f72b08215e175cece967f6c86a9bcf472e4d85bc"
    sha256 monterey:       "b49a9f852c06e2a0df9310f0e550d952cd0ae0a675a3a2eab44a51583a8089bb"
    sha256 big_sur:        "e8f4e1e32cba740b59dd9dfeea98c45d6fecfb3e5f52553da7963c92a83bc632"
    sha256 catalina:       "ebbc780bac1eac5bf0afb384a36eea408e8dc35369558b256eea4283ff2c0c39"
    sha256 x86_64_linux:   "9a72e30a88de8a164a4b249e181747639b9b2e2fc2b089f0e1cbaf850d6a0acb"
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
