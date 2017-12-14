class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "https://www.libjpeg-turbo.org/"
  url "https://downloads.sourceforge.net/project/libjpeg-turbo/1.5.3/libjpeg-turbo-1.5.3.tar.gz"
  sha256 "b24890e2bb46e12e72a79f7e965f409f4e16466d00e1dd15d93d73ee6b592523"

  bottle do
    cellar :any
    sha256 "8c95c24c19a4f7c80be4a7d226b69235011b04ba638f7b16d1f8908f17e41962" => :high_sierra
    sha256 "21f8159b00dadb55d54ac116fad05609c037232247de5a4a68cbecaf6370efa8" => :sierra
    sha256 "467f1bf4bdc4b6cda9a9dde47eafe13270183c6c1d8dfa13d6149d1f1ae02ca8" => :el_capitan
  end

  head do
    url "https://github.com/libjpeg-turbo/libjpeg-turbo.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  keg_only "libjpeg-turbo is not linked to prevent conflicts with the standard libjpeg"

  option "without-test", "Skip build-time checks (Not Recommended)"

  depends_on "libtool" => :build
  depends_on "nasm" => :build

  def install
    cp Dir["#{Formula["libtool"].opt_share}/libtool/*/config.{guess,sub}"], buildpath
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-jpeg8
      --mandir=#{man}
    ]

    system "autoreconf", "-fvi" if build.head?
    system "./configure", *args
    system "make"
    system "make", "test" if build.with? "test"
    ENV.deparallelize # Stops a race condition error: file exists
    system "make", "install"
  end

  test do
    system "#{bin}/jpegtran", "-crop", "1x1",
                              "-transpose", "-perfect",
                              "-outfile", "out.jpg",
                              test_fixtures("test.jpg")
  end
end
