class Opus < Formula
  desc "Audio codec"
  homepage "https://www.opus-codec.org/"
  url "https://archive.mozilla.org/pub/opus/opus-1.2.tar.gz"
  sha256 "77db45a87b51578fbc49555ef1b10926179861d854eb2613207dc79d9ec0a9a9"

  bottle do
    cellar :any
    sha256 "3094061c9de9b038a9b7e45472441cf06fa2b76fec729e2722eeda56a2ca99b6" => :sierra
    sha256 "a0d04fe1aa549a6bf80d5c54803b3c32a5fd669d38c7c94416076e4c73ed38d0" => :el_capitan
    sha256 "5ce71bb0df2d64a85129694e7bf62349afe1b62a56b876ab4fa65d364cec7ee3" => :yosemite
  end

  head do
    url "https://git.xiph.org/opus.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-custom-modes", "Enable custom-modes for opus see https://www.opus-codec.org/docs/opus_api-1.1.3/group__opus__custom.html"

  def install
    args = ["--disable-dependency-tracking", "--disable-doc", "--prefix=#{prefix}"]
    args << "--enable-custom-modes" if build.with? "custom-modes"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end
end
