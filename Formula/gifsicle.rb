class Gifsicle < Formula
  desc "GIF image/animation creator/editor"
  homepage "https://www.lcdf.org/gifsicle/"
  url "https://www.lcdf.org/gifsicle/gifsicle-1.91.tar.gz"
  sha256 "0a4ee602aa244cdcdd86a250a6b39c94d8343cf526b8fae862d8a0efc337a800"

  bottle do
    cellar :any_skip_relocation
    sha256 "43dde16013ef5a91813b9af8557e77908e9354cf689991de502e0bc58670d4e9" => :mojave
    sha256 "4be5faaf5e718e1838142cc547555c4e131ab460dc5f5f75fb7b1e539c28f69f" => :high_sierra
    sha256 "3a83d1bded9e8ffb909671c6bd2caf0a30a2e7dfd051335f8659f7cc38c93ad9" => :sierra
    sha256 "882e8c483f52f5c4e698381697f4e1a2e7fca2c7c1bb2daeffb6316397945931" => :el_capitan
  end

  head do
    url "https://github.com/kohler/gifsicle.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  conflicts_with "giflossy",
    :because => "both install an `gifsicle` binary"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-gifview
    ]

    system "./bootstrap.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/gifsicle", "--info", test_fixtures("test.gif")
  end
end
