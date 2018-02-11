class Libmpdclient < Formula
  desc "Library for MPD in the C, C++, and Objective-C languages"
  homepage "https://www.musicpd.org/libs/libmpdclient/"
  url "https://www.musicpd.org/download/libmpdclient/2/libmpdclient-2.14.tar.xz"
  sha256 "0a84e2791bfe3077cf22ee1784c805d5bb550803dffe56a39aa3690a38061372"
  head "https://github.com/MusicPlayerDaemon/libmpdclient.git"

  bottle do
    cellar :any
    sha256 "af530e739905c173c9327f560c7a04ba39f8c5a3476d1c2d0516be62dc967789" => :high_sierra
    sha256 "30f5b095ddc086dbb8d15b82f0184f83308c7bd5d020facacee2b27c54757add" => :sierra
    sha256 "56530667e499edce59960bf7e7ef3fe3cda08b96c9a8af1f6e056a98ae86c0fc" => :el_capitan
    sha256 "a4eab9eb2e1e33ef07412d5edb202983245f2a5b285771d352eb87c5fa162f4b" => :yosemite
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
