class Opus < Formula
  desc "Audio codec"
  homepage "https://www.opus-codec.org/"
  url "https://archive.mozilla.org/pub/opus/opus-1.1.4.tar.gz"
  sha256 "9122b6b380081dd2665189f97bfd777f04f92dc3ab6698eea1dbb27ad59d8692"

  bottle do
    cellar :any
    sha256 "fa157f731dac20c3da949a7e78756c6d274137d51161c41286f77d18fdf9846e" => :sierra
    sha256 "e978cb0514e9985ed819c16ad9858f905e15624dbc8a86bdf42bb42108f6a4b7" => :el_capitan
    sha256 "46c8d10883030bd6bf106277215535fa48e772d812b58dffafc7bafc43cd22b6" => :yosemite
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
