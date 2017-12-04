class Libcdio < Formula
  desc "Compact Disc Input and Control Library"
  homepage "https://www.gnu.org/software/libcdio/"
  url "https://ftp.gnu.org/gnu/libcdio/libcdio-1.0.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/libcdio/libcdio-1.0.0.tar.gz"
  sha256 "fe080bc3cb7a57becdecf2b392bf39c24df0211f5fdfddfe99748fa052a7e231"

  bottle do
    cellar :any
    sha256 "17bcfa0c5391620225be9852bedb7997d17fae812cd56899770607e4592306c6" => :high_sierra
    sha256 "30ae261789647c3f0bcaf7e9e3549b102f84dc0eca1dd656d4dbd29b5ada6967" => :sierra
    sha256 "fd901f0daca79021985ac158720c7036db9aca2e9bb186c5564b118143c59458" => :el_capitan
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/cd-info -v", 1)
  end
end
