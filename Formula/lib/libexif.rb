class Libexif < Formula
  desc "EXIF parsing library"
  homepage "https://libexif.github.io/"
  url "https://github.com/libexif/libexif/releases/download/v0.6.25/libexif-0.6.25.tar.bz2"
  sha256 "7c9eba99aed3e6594d8c3e85861f1c6aaf450c218621528bc989d3b3e7a26307"
  license all_of: ["LGPL-2.1-or-later", "LGPL-2.0-or-later"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "ef49b4bf108c622d0a0f18d5911230f489e1d93f5dcda597949125cad02d7389"
    sha256 arm64_sequoia: "db630e3ebf4c47a7c96f14e8edf29eaf88d89fbe2b0fb6737e1babdc39c230da"
    sha256 arm64_sonoma:  "a70285c25d276538094060000acea0828c0f0f287c5bea731b780f3a6d8357aa"
    sha256 arm64_ventura: "44869b2f698103429ec8a0f46613fa6acf144a1e5b237addadb1902cc482e8fd"
    sha256 sonoma:        "4ccd8b1a418d04e1991120ffb36e82b75dc255b3d652371f93b47032c4f5d829"
    sha256 ventura:       "2fe6759911975daa49a08569542b4ca535310b6260112dbf8b34f97247632980"
    sha256 arm64_linux:   "db6839524b1045b07572a9b3838dd98c6f3d041d762bd77ce8799a1a5fdff114"
    sha256 x86_64_linux:  "1426d9fdac3dcf9359098176fa0a8477c0b3fb05bae374e5fa9daedf3142aead"
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
