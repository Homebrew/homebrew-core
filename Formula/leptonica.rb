class Leptonica < Formula
  desc "Image processing and image analysis library"
  homepage "http://www.leptonica.org/"
  url "http://www.leptonica.org/source/leptonica-1.73.tar.gz"
  sha256 "19e4335c674e7b78af9338d5382cc5266f34a62d4ce533d860af48eaa859afc1"

  bottle do
    cellar :any
    sha256 "ec8fe0b657e0a3a79564e3ba78451699201e23b0b8e9da3e342a05139df71e7c" => :sierra
    sha256 "9d27186bb860962f3df77a8467194b18a660af2406451218b4e61c277d1e8470" => :el_capitan
    sha256 "0fed0bd62f53161a0b68dc466f6a3fae405c8850f21683fbe995e5b4483ec635" => :yosemite
    sha256 "48a9b224ae3cbe80f921cc82b17984c789a33a39a8f03fd59b96c53fa7aff9be" => :mavericks
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
        std::fprintf(stdout, "%d.%d", LIBLEPT_MAJOR_VERSION, LIBLEPT_MINOR_VERSION);
        return 0;
    }
    EOS

    flags = ["-I#{include}/leptonica"] + ENV.cflags.to_s.split
    system ENV.cxx, "test.cpp", *flags
    assert_equal version.to_s, `./a.out`
  end
end
