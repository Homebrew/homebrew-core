class Libmpdclient < Formula
  desc "Library for MPD in the C, C++, and Objective-C languages"
  homepage "https://www.musicpd.org/libs/libmpdclient/"
  url "https://www.musicpd.org/download/libmpdclient/2/libmpdclient-2.13.tar.xz"
  sha256 "5115bd52bc20a707c1ecc7587e6389c17305348e2132a66cf767c62fc55ed45d"
  head "git://git.musicpd.org/master/libmpdclient.git"

  bottle do
    cellar :any
    sha256 "264914a87afdba24d2ade99a10d43470907cee12ecb07b863f9381afc4516927" => :sierra
    sha256 "cea26f473cb4791365fc8da31b0d73202616e731dcc827a14e37f2d004470a25" => :el_capitan
    sha256 "05bfb56583a4144507dd9102101a5136210295324057f03aab41841aab03b4e0" => :yosemite
  end

  depends_on "doxygen" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "--prefix=#{prefix}", ".", "output"
    system "ninja", "-C", "output"
    system "ninja", "-C", "output", "install"
  end
end
