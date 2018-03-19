class Giflossy < Formula
  desc "Lossy LZW compression, reduces GIF file sizes by 30-50%"
  homepage "https://pornel.net/lossygif"
  url "https://github.com/kornelski/giflossy/archive/1.91.tar.gz"
  sha256 "b97f6aadf163ff5dd96ad1695738ad3d5aa7f1658baed8665c42882f11d9ab22"
  head "https://github.com/kornelski/giflossy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "56c413383c1f4978f1820086aca1d6f61a3b0b89d8df9ec946320d5aeb4a7868" => :high_sierra
    sha256 "3cf3c0757688012aad91066611bf6851f26b6ca246e6014a43da7abeca1f6b77" => :sierra
    sha256 "b1003fafaa5c7bbdf956a7ac4f8c0c06abf4c583b922bf67e1eacb1498db0b16" => :el_capitan
    sha256 "2c4d49abc644aa4e98eaaae86002c7153bf9e3990186e730d9ebb3ff4ceb0b22" => :yosemite
    sha256 "96c42819acabd42287e2e032f10969e9ac08bfb28848626ac0df4f926f116a99" => :mavericks
    sha256 "1e71bcca774a3f01d8ede50d6040d06c2f25df7e6e3635efab4c5daf06f2bcb1" => :mountain_lion
  end

  option "with-x11", "Install gifview"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on :x11 => :optional

  conflicts_with "gifsicle",
    :because => "both install an `gifsicle` binary"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--disable-gifview" if build.without? "x11"

    system "autoreconf", "-fvi"
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"gifsicle", "-O3", "--lossy=80", "-o",
                           "out.gif", test_fixtures("test.gif")
  end
end
