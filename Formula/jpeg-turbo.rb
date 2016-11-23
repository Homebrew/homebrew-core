class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "http://www.libjpeg-turbo.org/"
  url "https://downloads.sourceforge.net/project/libjpeg-turbo/1.5.1/libjpeg-turbo-1.5.1.tar.gz"
  sha256 "41429d3d253017433f66e3d472b8c7d998491d2f41caa7306b8d9a6f2a2c666c"

  bottle do
    cellar :any
    sha256 "a2aa24949f11a108120cb753c2a78bf98ef308ce6403c5c8ae051c0611e313e7" => :sierra
    sha256 "147386c1824c1abdc11d49f6f7b3d3350a90cd400f3dbac2a699b86dd3442795" => :el_capitan
    sha256 "7278b7093b4ecf4d8dfd33e01663ea5fac5774d785511158b45ee375cb58a103" => :yosemite
    sha256 "a3bd1c1936800ab4cf819135963574edd2f7a7851283c640c3c587024a45908c" => :mavericks
  end

  head do
    url "https://github.com/libjpeg-turbo/libjpeg-turbo.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  keg_only "libjpeg-turbo is not linked to prevent conflicts with the standard libjpeg."

  option "without-test", "Skip build-time checks (Not Recommended)"

  depends_on "libtool" => :build
  depends_on "nasm" => :build

  def install
    cp Dir["#{Formula["libtool"].opt_share}/libtool/*/config.{guess,sub}"], buildpath
    args = %W[--disable-dependency-tracking --prefix=#{prefix} --with-jpeg8 --mandir=#{man}]

    system "autoreconf", "-fvi" if build.head?
    system "./configure", *args
    system "make"
    system "make", "test" if build.with? "test"
    ENV.j1 # Stops a race condition error: file exists
    system "make", "install"
  end

  test do
    system "#{bin}/jpegtran", "-crop", "1x1",
                              "-transpose", "-perfect",
                              "-outfile", "out.jpg",
                              test_fixtures("test.jpg")
  end
end
