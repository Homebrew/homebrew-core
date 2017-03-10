class Jpeg6b < Formula
  desc "Image manipulation library"
  homepage "http://www.ijg.org"
  url "http://www.ijg.org/files/jpegsrc.v6b.tar.gz"
  sha256 "75c3ec241e9996504fe02a9ed4d12f16b74ade713972f3db9e65ce95cd27e35d"

  keg_only :versioned_formula

  depends_on "libtool" => :build

  def install
    bin.mkpath
    lib.mkpath
    include.mkpath
    man1.mkpath

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-shared"

    system "make", "install", "install-lib", "install-headers",
                   "mandir=#{man1}", "LIBTOOL=glibtool"
  end

  test do
    system "#{bin}/djpeg", test_fixtures("test.jpg")
  end
end
