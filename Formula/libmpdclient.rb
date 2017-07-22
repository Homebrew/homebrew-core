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
    sha256 "ab84b63fdac72459fe7cff11655ef233ae2561aa218177229d40f4848e1c452d" => :sierra
    sha256 "1fa73b275597ded3bbed6a39aadce1dd9af6f77711c4cfd8f3d9a50b31e3662a" => :el_capitan
    sha256 "98202831315d735c430e8b7071f513b4eafb3715bbcf51090db87b451d59d242" => :yosemite
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
