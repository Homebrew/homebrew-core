class Dos2unix < Formula
  desc "Convert text between DOS, UNIX, and Mac formats"
  homepage "https://waterlan.home.xs4all.nl/dos2unix.html"
  url "https://waterlan.home.xs4all.nl/dos2unix/dos2unix-7.5.0.tar.gz"
  mirror "https://fossies.org/linux/misc/dos2unix-7.5.0.tar.gz"
  sha256 "7a3b01d01e214d62c2b3e04c3a92e0ddc728a385566e4c0356efa66fd6eb95af"
  license "BSD-2-Clause"

  livecheck do
    url "https://waterlan.home.xs4all.nl/dos2unix/"
    regex(/href=.*?dos2unix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f30f0ff347c2857d90a0558af2fa674bcb4d4daadf08da970b9741f7ee24d914"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fbbcc220adea02b5584446aacf757c097be5c13e2803a8bf4f772ef51cf6501"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2542b8e620eee7b5f7565aa11469d66a93ec43b366a0b494dbe8338fc5dcbe47"
    sha256 cellar: :any_skip_relocation, ventura:        "f9dd335c6b5e2329c843cb45fd9159188a20668f83f17f83bb74d8787b5c3b30"
    sha256 cellar: :any_skip_relocation, monterey:       "2f6fea4d8d5b4dbf1038d8dfd53708b89dafbf0e2800a673e8ecb65546ccd325"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f5a9c2dc29d0df1daa304c5fca1dcbba5e9c14fd3cd85144ba6a871be31c48c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a699ed735f09fa9c74be0fc6955f85d3f36f06f8e5f2a97331e1c9d290e7a604"
  end

  def install
    args = %W[
      prefix=#{prefix}
      CC=#{ENV.cc}
      CPP=#{ENV.cc}
      CFLAGS=#{ENV.cflags}
      ENABLE_NLS=
      install
    ]

    system "make", *args
  end

  test do
    # write a file with lf
    path = testpath/"test.txt"
    path.write "foo\nbar\n"

    # unix2mac: convert lf to cr
    system "#{bin}/unix2mac", path
    assert_equal "foo\rbar\r", path.read

    # mac2unix: convert cr to lf
    system "#{bin}/mac2unix", path
    assert_equal "foo\nbar\n", path.read

    # unix2dos: convert lf to cr+lf
    system "#{bin}/unix2dos", path
    assert_equal "foo\r\nbar\r\n", path.read

    # dos2unix: convert cr+lf to lf
    system "#{bin}/dos2unix", path
    assert_equal "foo\nbar\n", path.read
  end
end
