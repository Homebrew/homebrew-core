class Opus < Formula
  desc "Audio codec"
  homepage "https://www.opus-codec.org/"
  url "https://archive.mozilla.org/pub/opus/opus-1.2.1.tar.gz"
  sha256 "cfafd339ccd9c5ef8d6ab15d7e1a412c054bf4cb4ecbbbcc78c12ef2def70732"

  bottle do
    cellar :any
    sha256 "ff986676ae53fdfb7b2af18c896be5d284a3e7b51ad0a94b8fa5a651dcc74201" => :sierra
    sha256 "9db3f7606381e0f60477f18c70cdf4bbf68c948ae9c6ead7a5bd6aa62aeab63b" => :el_capitan
    sha256 "adf030f2d3fa1260acb54515ced82474a626d6d2ad015ea3ace404a79e09f1c4" => :yosemite
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
