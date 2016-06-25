class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "http://www.libjpeg-turbo.org/"
  url "https://downloads.sourceforge.net/project/libjpeg-turbo/1.5.0/libjpeg-turbo-1.5.0.tar.gz"
  sha256 "9f397c31a67d2b00ee37597da25898b03eb282ccd87b135a50a69993b6a2035f"

  bottle do
    cellar :any
    revision 1
    sha256 "c524034d381690f5dee1f7eee404698dfd982466a931e9b0bab87a3444dfb674" => :el_capitan
    sha256 "cf44e7bbfe0275f93075cc5d20d7295fe35e886c62b7f90628fa366c25663bbd" => :yosemite
    sha256 "027546110317081bbd4d50687a801457c70bfda1dcfb28f9522ca234e173a9dc" => :mavericks
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
