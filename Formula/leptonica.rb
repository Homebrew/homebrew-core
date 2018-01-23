class Leptonica < Formula
  desc "Image processing and image analysis library"
  homepage "http://www.leptonica.org/"
  url "https://github.com/DanBloomberg/leptonica/releases/download/1.75.0/leptonica-1.75.0.tar.gz"
  mirror "http://www.leptonica.org/source/leptonica-1.75.0.tar.gz"
  sha256 "def1a40e30f69fd3c80d9063bdd69fa50451d45e773b8609cffce7d42f287652"

  bottle do
    cellar :any
    sha256 "003dce941c5eb1d0faf314fae1fd4501f023e29b0b73ddb20a72ff807a48aa7c" => :high_sierra
    sha256 "824ca9ea9a3c6a0908f576288cf392244e0cab32835a3b01c8d125c8195ae476" => :sierra
    sha256 "e567de6c8cb4caabe45b61e314fa482e8792bc1c3719755760ee55a694096716" => :el_capitan
    sha256 "b1b8d75b21f7512dabd7cf665dbda4977bf1b34cc61bdc0daa23748a9c072208" => :yosemite
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
