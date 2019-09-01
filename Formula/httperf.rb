class Httperf < Formula
  desc "Tool for measuring webserver performance"
  homepage "https://github.com/httperf/httperf"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/httperf/httperf-0.9.0.tar.gz"
  sha256 "e1a0bf56bcb746c04674c47b6cfa531fad24e45e9c6de02aea0d1c5f85a2bf1c"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "464f6bb62b9981873d450cafc2495742672824eb04afbd40a9b1396a83cfb486" => :mojave
    sha256 "05ec93942b088eeb3bcbad50c6a79dc85525dc48a001c524fcd9216b0791ee49" => :high_sierra
    sha256 "c2b62dd37efe18f1018e2481e674ef9f8273c55e246bd58515dd26250db13f0d" => :sierra
  end

  # Upstream actually recommend using head over stable now.
  head do
    url "https://github.com/httperf/httperf.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl" # no OpenSSL 1.1 support

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system "#{bin}/httperf", "--version"
  end
end
