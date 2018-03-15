class Leptonica < Formula
  desc "Image processing and image analysis library"
  homepage "http://www.leptonica.org/"
  url "https://github.com/DanBloomberg/leptonica/releases/download/1.75.3/leptonica-1.75.3.tar.gz"
  mirror "http://www.leptonica.org/source/leptonica-1.75.3.tar.gz"
  sha256 "a00f8fb06829ca6c8262bec8f78a6f985e049786f7c872a37b72fd7051ea087a"

  bottle do
    cellar :any
    sha256 "0b8f3285895d84b449ebf336529f1331dfab5419d9c4b96d41c45fc6ab0d3014" => :high_sierra
    sha256 "3d7128f26633bd7b62b21c2ad330d740dcbcd5be25434e4ad51a2e42757bcfca" => :sierra
    sha256 "81dd56c481c6ec775d8645cecefe02489d6cd4cf36fe22e005ae61f9c1501e13" => :el_capitan
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
