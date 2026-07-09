class Libexif < Formula
  desc "EXIF parsing library"
  homepage "https://libexif.github.io/"
  url "https://github.com/libexif/libexif/releases/download/v0.6.26/libexif-0.6.26.tar.bz2"
  sha256 "0830ed253fceeb60444fb309598bc8a9491d3007dc054aad3a50a347c5597c57"
  license all_of: ["LGPL-2.1-or-later", "LGPL-2.0-or-later"]
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "124b33b57bbf93384d1155983930a81b258d1358b1eff29ec17ac5bc868b0aea"
    sha256 arm64_sequoia: "de8d0b2637cf96b06dd2e4e5d89e75511d1b6cdf4f6b82894ec7e1219e614c69"
    sha256 arm64_sonoma:  "3efa42a370d416f5f9ea9bceed5bfbee25b7110e2b6d299af448bf877e665401"
    sha256 sonoma:        "020318b7bd815dfed8dddefa9e824123b61f3b19b8f574fba91dab98053ddbb1"
    sha256 arm64_linux:   "6b89826eaeef82ae698829e319b553ef87635915f5b907267db66d239d2eb67f"
    sha256 x86_64_linux:  "4389caca58aaf778b35bc8d7ade6e863df28735894f69b7c2473ac96c44ac971"
  end

  head do
    url "https://github.com/libexif/libexif.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  on_macos do
    depends_on "gettext"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
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
