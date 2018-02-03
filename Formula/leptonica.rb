class Leptonica < Formula
  desc "Image processing and image analysis library"
  homepage "http://www.leptonica.org/"
  url "https://github.com/DanBloomberg/leptonica/releases/download/1.75.1/leptonica-1.75.1.tar.gz"
  mirror "http://www.leptonica.org/source/leptonica-1.75.1.tar.gz"
  sha256 "3c5402326ed4c4d9844813675348c3d7156cd868cfe4565dd078e295f477a831"

  bottle do
    cellar :any
    sha256 "a3cd1180cd87533ed42ba5b0b4b43df9c4a13607ed81a14949b1539df5ef7371" => :high_sierra
    sha256 "dfc941dcb2602d65e91f55e3d0efaf66734c37e49150504b2e16c1a628a8e787" => :sierra
    sha256 "c13601ecc960bfc0857c620027d985f2ced78d2a586843bc90a2c8ca3b93a290" => :el_capitan
  end

  depends_on "libpng" => :recommended
  depends_on "jpeg" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "giflib" => :optional
  depends_on "openjpeg" => :optional
  depends_on "webp" => :optional
  depends_on "pkg-config" => :build

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    %w[libpng jpeg libtiff giflib].each do |dep|
      args << "--without-#{dep}" if build.without?(dep)
    end
    %w[openjpeg webp].each do |dep|
      args << "--with-lib#{dep}" if build.with?(dep)
      args << "--without-lib#{dep}" if build.without?(dep)
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS
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
