class Leptonica < Formula
  desc "Image processing and image analysis library"
  homepage "http://www.leptonica.org/"
  url "https://github.com/DanBloomberg/leptonica/releases/download/1.75.2/leptonica-1.75.2.tar.gz"
  mirror "http://www.leptonica.org/source/leptonica-1.75.2.tar.gz"
  sha256 "b6af3b43a1d38984a8f5201222297ca51e2ad511bdf709847a806f9d90031a8a"

  bottle do
    cellar :any
    sha256 "24f90d6a77ffef528c184679663017f551fbcd6202bbe79462960b71944d8583" => :high_sierra
    sha256 "fe32cc6350f6e26392993b4dc02d520b9aa27d43117ae0e8c349cc0a02baf5a9" => :sierra
    sha256 "d7338b13bc2cba7f15ff73a92f2e868aa5f57141edd043fe48384cb3dbe873ad" => :el_capitan
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
