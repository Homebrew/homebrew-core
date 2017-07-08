class Leptonica < Formula
  desc "Image processing and image analysis library"
  homepage "http://www.leptonica.org/"
  url "https://github.com/DanBloomberg/leptonica/releases/download/1.74.4/leptonica-1.74.4.tar.gz"
  mirror "http://www.leptonica.org/source/leptonica-1.74.4.tar.gz"
  sha256 "29c35426a416bf454413c6fec24c24a0b633e26144a17e98351b6dffaa4a833b"

  bottle do
    cellar :any
    sha256 "e15c1a9d55f926ff2665e9e9a18b6865506d6106474237b2f0e28b95b2253db6" => :sierra
    sha256 "aae7d2d5d03176734707c5900d6e37fc7a9ef282b4429b5477d2a4415b50d59e" => :el_capitan
    sha256 "6e7e6f9085592590d5ab8728a58674667e486dbf62d12737261a0c283bbd8ed1" => :yosemite
  end

  depends_on "libpng" => :recommended
  depends_on "jpeg" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "giflib" => :optional
  depends_on "openjpeg" => :optional
  depends_on "webp" => :optional
  depends_on "pkg-config" => :build

  conflicts_with "osxutils",
    :because => "both leptonica and osxutils ship a `fileinfo` executable."

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
