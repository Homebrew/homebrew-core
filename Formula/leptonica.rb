class Leptonica < Formula
  desc "Image processing and image analysis library"
  homepage "http://www.leptonica.org/"
  url "https://github.com/DanBloomberg/leptonica/releases/download/1.75.0/leptonica-1.75.0.tar.gz"
  mirror "http://www.leptonica.org/source/leptonica-1.75.0.tar.gz"
  sha256 "def1a40e30f69fd3c80d9063bdd69fa50451d45e773b8609cffce7d42f287652"

  bottle do
    cellar :any
    sha256 "2734d2df82914756f80473265f3babac69b851ea776081b05b1f8292d15e5697" => :high_sierra
    sha256 "21925fe1b9f78721e5c0dee6b92aff38f952dee49430b58b4f696e16396664f5" => :sierra
    sha256 "6449817bb92ceea1f5863a6b88485072acd6ba2dc1ac798e2854a343ac085db1" => :el_capitan
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
