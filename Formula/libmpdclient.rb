class Libmpdclient < Formula
  desc "Library for MPD in the C, C++, and Objective-C languages"
  homepage "https://www.musicpd.org/libs/libmpdclient/"
  head "git://git.musicpd.org/master/libmpdclient.git"

  stable do
    url "https://www.musicpd.org/download/libmpdclient/2/libmpdclient-2.12.tar.xz"
    sha256 "9ecd1ed8f6e355c622ab10af4aef5fb06da21d2ffc5b6313747d0245ad8279f8"

    # Fix build failure "Tried to form an absolute path to a source dir"
    # Upstream PR from 22 Jul 2017 "meson.build: fix build with meson > 0.38.1"
    patch do
      url "https://github.com/MusicPlayerDaemon/libmpdclient/pull/4.patch?full_index=1"
      sha256 "402591fadcac4aab99081f9e927b8b6487fb6778351da3088f45508a04317dc1"
    end
  end

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
