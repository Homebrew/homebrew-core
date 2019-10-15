class Giflossy < Formula
  desc "Lossy LZW compression, reduces GIF file sizes by 30-50%"
  homepage "https://pornel.net/lossygif"
  url "https://github.com/kornelski/giflossy/archive/1.91.tar.gz"
  sha256 "b97f6aadf163ff5dd96ad1695738ad3d5aa7f1658baed8665c42882f11d9ab22"
  head "https://github.com/kornelski/giflossy.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e3b6e1b39169c52c0f96b02ff68b43f4e8f297c830d290288221e17a5c130839" => :catalina
    sha256 "9a0c85d6e19b61c8f232ab36211f8952220a62e5ca0f1c1f57de8280782dbc36" => :mojave
    sha256 "492ddf714381465db00b10689af119d8c225ca5138304d8f1e6c946b9cf67e76" => :high_sierra
    sha256 "464798aef709d62f6bfb4cefd3cb9d084e3aced492766e63b113762f15347d19" => :sierra
    sha256 "50e8538008faf1bb05e8d44801cacd6e8f41fbf392ed23b639c7d05d36b5c8d8" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  conflicts_with "gifsicle",
    :because => "both install an `gifsicle` binary"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-gifview
    ]

    system "autoreconf", "-fvi"
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"gifsicle", "-O3", "--lossy=80", "-o",
                           "out.gif", test_fixtures("test.gif")
  end
end
