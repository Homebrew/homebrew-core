class Libcdio < Formula
  desc "Compact Disc Input and Control Library"
  homepage "https://www.gnu.org/software/libcdio/"
  url "https://ftp.gnu.org/gnu/libcdio/libcdio-1.0.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/libcdio/libcdio-1.0.0.tar.gz"
  sha256 "fe080bc3cb7a57becdecf2b392bf39c24df0211f5fdfddfe99748fa052a7e231"

  bottle do
    cellar :any
    sha256 "a6ad3bc9df9cbe1d8d94adb9c5e3613210558ec547fb93dd59eb7727c12d948f" => :high_sierra
    sha256 "a33a83ce904f907197bea29caab598b3fb505c0057a720e4b0ac1d7f8b19e15c" => :sierra
    sha256 "b875027374fb8585468bc1c75161ff893598ec0f5490b6d542fd5a80b7e77052" => :el_capitan
    sha256 "45f6e37c831b5cbadd68721efc070196b0946b24f4ac05d532b4fcd65d30289b" => :yosemite
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
