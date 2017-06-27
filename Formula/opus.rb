class Opus < Formula
  desc "Audio codec"
  homepage "https://www.opus-codec.org/"
  url "https://archive.mozilla.org/pub/opus/opus-1.2.1.tar.gz"
  sha256 "cfafd339ccd9c5ef8d6ab15d7e1a412c054bf4cb4ecbbbcc78c12ef2def70732"

  bottle do
    cellar :any
    sha256 "c6735b7940d840d1d6a3f5f30459a47b8b98ceb83063f82cfbe99b44942a88e1" => :sierra
    sha256 "b9521c137a8166b207bc7c6da6bc0be4ebabaa9b439672cbe8b70126b67e718f" => :el_capitan
    sha256 "9a678e710d79dd73464647d1fcba5f745295dfa11986e35d2a331a161ce4cd63" => :yosemite
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
