class Gifsicle < Formula
  desc "GIF image/animation creator/editor"
  homepage "https://www.lcdf.org/gifsicle/"
  url "https://www.lcdf.org/gifsicle/gifsicle-1.91.tar.gz"
  sha256 "0a4ee602aa244cdcdd86a250a6b39c94d8343cf526b8fae862d8a0efc337a800"

  bottle do
    cellar :any_skip_relocation
    sha256 "d58f0a76408cd3127fef7fca4760f3a322544838389cb3ed43e6d41e33149ecb" => :high_sierra
    sha256 "1064f9cf5d0fe604c378e0390f2d79ceacdaa99f2d3d76873a0fc904e6f13718" => :sierra
    sha256 "4f8cd7b0a09eed64ce5e8761b8f228b976c1e30fad55d06855f28a7f9d123b35" => :el_capitan
    sha256 "7cb0e1cae0253622e6eb72081412e448ab10f3b69a9aef9ea1597f45c42db799" => :yosemite
  end

  head do
    url "https://github.com/kohler/gifsicle.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "with-x11", "Install gifview"

  depends_on :x11 => :optional

  conflicts_with "giflossy",
    :because => "both install an `gifsicle` binary"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--disable-gifview" if build.without? "x11"

    system "./bootstrap.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/gifsicle", "--info", test_fixtures("test.gif")
  end
end
