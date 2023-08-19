class Ncdc < Formula
  desc "NCurses direct connect"
  homepage "https://dev.yorhel.nl/ncdc"
  url "https://dev.yorhel.nl/download/ncdc-1.23.1.tar.gz"
  sha256 "95881214077a5b3c24fbbaf020ada0d084ee3b596a7c3cc1e0e68aaac4c9b5e6"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?ncdc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "98457589a1d9849757717a82ae339760498fc175be64629f3b0ffb983cb1b1d5"
    sha256 cellar: :any,                 arm64_monterey: "53c31dd30f67aed950af38ff4c38caa28d3457be2e0c0a37ff458a36850126e9"
    sha256 cellar: :any,                 arm64_big_sur:  "98556bfc802f5fcf60afe2233c49f214f6cde7c55455f1cb0faa3b69661e4d6c"
    sha256 cellar: :any,                 ventura:        "0de5298a38529b43420a6baad568a0f68f9daba603d38ef0d74feacc63f76352"
    sha256 cellar: :any,                 monterey:       "322804a1c48dc8c02ad86dc62a8201cdf2396922e3b1192a33ca4e164ec3110d"
    sha256 cellar: :any,                 big_sur:        "f58142f3ee9f4e59823506472ad771d6eb6a0ca6ba4bc24d52c08668854f8cc9"
    sha256 cellar: :any,                 catalina:       "b97cd73d131b3635595adedffdd2044cc8f39b6d32b3e0d35dc2c6e9b6a280d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "367c1d0a6db764a9e04b6a71cd0da854cb827ea762a5df1a66f4c39f8b1ef417"
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
