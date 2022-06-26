class Ncdc < Formula
  desc "NCurses direct connect"
  homepage "https://dev.yorhel.nl/ncdc"
  url "https://dev.yorhel.nl/download/ncdc-1.23.tar.gz"
  sha256 "804abae41fcca969e87f650483ae7e3a237419dabbd320897e25fe8851f0a2cb"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?ncdc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "727da515f470c72550a7460230aa2172f6c49ad915a8dbc0130e6f5ecb04d631"
    sha256 cellar: :any,                 arm64_big_sur:  "bbd57ae7047c9f06bbde9ed28e168abc5d392d36ed1a9c125edf059611f07694"
    sha256 cellar: :any,                 monterey:       "e5ba6e94980ebfec5e26e78289da6212c1da5719ed5e120cd98e6521819d824e"
    sha256 cellar: :any,                 big_sur:        "f34ecec366f3d0779c80ce292eadaa23f00f7d817fbfcd26b6888dfd1bf58990"
    sha256 cellar: :any,                 catalina:       "0a929234d7c4d2a3585a0f5bee7cd6a6cd4487e0e2b04dd501ec680f03785522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46cf9b85ad77d41c2f4159b70a9456416cced4887e1aaf8997e1734da0ebf464"
  end

  head do
    url "https://g.blicky.net/ncdc.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gnutls"
  depends_on "ncurses"
  depends_on "sqlite"

  def install
    system "autoreconf", "-ivf" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/ncdc", "-v"
  end
end
