class Leptonica < Formula
  desc "Image processing and image analysis library"
  homepage "http://www.leptonica.org/"
  url "https://github.com/DanBloomberg/leptonica/releases/download/1.77.0/leptonica-1.77.0.tar.gz"
  sha256 "161d0b368091986b6c60990edf257460bdc7da8dd18d48d4179e297bcdca5eb7"
  revision 1

  bottle do
    cellar :any
    sha256 "43edf41dc303d9aa89e6b03663a81eab3a28c4cd5a319d064b6dae4c841a0553" => :mojave
    sha256 "06ef285a85c0797f177faaddc4f727526afb7757d6c673fb1a8eb29fc9b9ff23" => :high_sierra
    sha256 "d730eb3b285fb88fba5496157a5d26ee4d3460f5414b0aee811ea715d09e550f" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "giflib"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openjpeg"
  depends_on "webp"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-libwebp
      --with-libopenjpeg
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <leptonica/allheaders.h>

      int main(int argc, char **argv) {
          std::fprintf(stdout, "%d.%d.%d", LIBLEPT_MAJOR_VERSION, LIBLEPT_MINOR_VERSION, LIBLEPT_PATCH_VERSION);
          return 0;
      }
    EOS

    flags = ["-I#{include}/leptonica"] + ENV.cflags.to_s.split
    system ENV.cxx, "test.cpp", *flags
    assert_equal version.to_s, `./a.out`
  end
end
