class Leptonica < Formula
  desc "Image processing and image analysis library"
  homepage "http://www.leptonica.org/"
  url "https://github.com/DanBloomberg/leptonica/releases/download/1.74.4/leptonica-1.74.4.tar.gz"
  mirror "http://www.leptonica.org/source/leptonica-1.74.4.tar.gz"
  sha256 "29c35426a416bf454413c6fec24c24a0b633e26144a17e98351b6dffaa4a833b"
  revision 1

  bottle do
    cellar :any
    sha256 "7c6a428194e9f30bf8d938a4d83a2aebd2344017bca2ec37548fa54c25a59e63" => :sierra
    sha256 "5906771c4839ce2c38e3bff2d4bb2b4085560a1275c03884ecf2149bbefd2bb8" => :el_capitan
    sha256 "edf27c88591a2ff1bdb31d7a9c3cbab98a6fd81af0e5c3568e7736bb632ec046" => :yosemite
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
