class Libcdio < Formula
  desc "Compact Disc Input and Control Library"
  homepage "https://www.gnu.org/software/libcdio/"
  url "https://ftp.gnu.org/gnu/libcdio/libcdio-2.0.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/libcdio/libcdio-2.0.0.tar.gz"
  sha256 "1b481b5da009bea31db875805665974e2fc568e2b2afa516f4036733657cf958"

  bottle do
    cellar :any
    sha256 "0588985627d357573bafd4bb1c1a096d824153142df3ae9c77b59d1cb8e8ee50" => :mojave
    sha256 "7a0da4716a8c2d0c15a474bb33df7bfaad1639b7bb80c3039b3d7e5af04c9c64" => :high_sierra
    sha256 "d20beb64a3895d5c5b749b371cc8dc23ba50813a07c22ee10691c8b80c6ffc5c" => :sierra
    sha256 "736e98f2264c013a19af40ca1db8695326fb96e5292d0f31accaed0fe74e50fe" => :el_capitan
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
