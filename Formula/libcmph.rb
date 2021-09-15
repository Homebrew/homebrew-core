class Libcmph < Formula
  desc "C minimal perfect hashing library"
  homepage "https://cmph.sourceforge.io"
  url "https://downloads.sourceforge.net/project/cmph/v2.0.2/cmph-2.0.2.tar.gz"
  sha256 "365f1e8056400d460f1ee7bfafdbf37d5ee6c78e8f4723bf4b3c081c89733f1e"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "30d22ddad3521ec07248910864e8caae7f8d959597663a9d21d2447c56e6639c"
    sha256 cellar: :any,                 big_sur:       "f1cc2211ac56a2702405246535a55613855c3879885ca73aa65d76890c2aa0e5"
    sha256 cellar: :any,                 catalina:      "c38019c153c728a28acbfe340cc86764285ec24edbdba5234b0593f83d355c22"
    sha256 cellar: :any,                 mojave:        "d02c761bd6b52424528bfdcd56b8d469d7cdd2e55f625c719229edb7f011889c"
    sha256 cellar: :any,                 high_sierra:   "abffeaf075db6387e636d43eb8fda9b76f02091bdb5533368306f899a46406c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b4a556fa47365d3ebf9312acddf3fc64921094161bd6d6e1bcda3df92be70cd"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
