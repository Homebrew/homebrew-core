class Diffutils < Formula
  desc "File comparison utilities"
  homepage "https://www.gnu.org/s/diffutils/"
  url "https://ftp.gnu.org/gnu/diffutils/diffutils-3.9.tar.xz"
  mirror "https://ftpmirror.gnu.org/diffutils/diffutils-3.9.tar.xz"
  sha256 "d80d3be90a201868de83d78dad3413ad88160cc53bcc36eb9eaf7c20dbf023f1"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f604055fb7f084ee809aa7018743e68af73c6aade0fea14dfa2c10d6b89c45f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a626d7df9922f4836ea7b6c08f854c10b691b92b40574dc050671620e2e62ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67302e472f8601da64626b70b2f2a8bd5c65a5a27229a348f8fbbe51ac321dbf"
    sha256 cellar: :any_skip_relocation, ventura:        "2e6815910c334366278d01b5cafdaa2388ae0c40cddf4d19c69d9dfeaa964a07"
    sha256 cellar: :any_skip_relocation, monterey:       "913161dcbc00975f71c77a596e5d18c4796cee0fbdfbe86a204d590dc4c7c919"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2f09c87d1e9ee416992933f8e929a4cdf508359c975fc2a6a752279d7ce7d9b"
    sha256                               x86_64_linux:   "11c1772a7870b94e28409bf611324d913502d742a117267955adc8a8bf1f8e7b"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"a").write "foo"
    (testpath/"b").write "foo"
    system bin/"diff", "a", "b"
  end
end
