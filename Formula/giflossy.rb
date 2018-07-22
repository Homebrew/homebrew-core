class Giflossy < Formula
  desc "Lossy LZW compression, reduces GIF file sizes by 30-50%"
  homepage "https://pornel.net/lossygif"
  url "https://github.com/kornelski/giflossy/archive/1.91.tar.gz"
  sha256 "b97f6aadf163ff5dd96ad1695738ad3d5aa7f1658baed8665c42882f11d9ab22"
  head "https://github.com/kornelski/giflossy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b81704f64e9bdac63646b92be361303215e24088f662a24c257a01de7fb4f734" => :high_sierra
    sha256 "1b720c57508a15ac50a2f6340532115049a455098e2db1e98ea621e175dfd04a" => :sierra
    sha256 "a770a479a8fcd961ceef0274fc8aa75f70fa7b1f4bb8cb34736c0d6902340e1c" => :el_capitan
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
