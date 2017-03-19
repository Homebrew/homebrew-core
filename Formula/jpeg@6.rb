class JpegAT6 < Formula
  desc "Image manipulation library"
  homepage "http://www.ijg.org"
  url "http://www.ijg.org/files/jpegsrc.v6b.tar.gz"
  sha256 "75c3ec241e9996504fe02a9ed4d12f16b74ade713972f3db9e65ce95cd27e35d"

  bottle do
    cellar :any
    sha256 "db6b954915dc25cd03ee951bf628b683221393d486f5d0c83fc3b62e7a5871bf" => :sierra
    sha256 "aa8c01f40b317e3f1430035903cd6204068b1e296768be7e67e9b2d0b3458aa6" => :el_capitan
    sha256 "abbe4355a48e6d8fd54fa5b35704867e44374fed74a0d76efe303c48f8b8f2af" => :yosemite
  end

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
