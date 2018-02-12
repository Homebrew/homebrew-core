class Libmpdclient < Formula
  desc "Library for MPD in the C, C++, and Objective-C languages"
  homepage "https://www.musicpd.org/libs/libmpdclient/"
  url "https://www.musicpd.org/download/libmpdclient/2/libmpdclient-2.14.tar.xz"
  sha256 "0a84e2791bfe3077cf22ee1784c805d5bb550803dffe56a39aa3690a38061372"
  head "https://github.com/MusicPlayerDaemon/libmpdclient.git"

  bottle do
    cellar :any
    sha256 "03ad207b62c19b8b7e8368f28245cb6c939e15babb68fab3d6958ebb14e2f6a4" => :high_sierra
    sha256 "5fc405af3eea66abec93720732c65cb6220c610bda522119a21b0d14f68e3baf" => :sierra
    sha256 "b21a61625915e0e94fe52e16ea64a142588f621cb1a56e7cb931bcab1502af2f" => :el_capitan
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
