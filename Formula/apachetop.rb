class Apachetop < Formula
  desc "Top-like display of Apache log"
  homepage "https://web.archive.org/web/20170809160553/freecode.com/projects/apachetop"
  url "https://deb.debian.org/debian/pool/main/a/apachetop/apachetop_0.19.7.orig.tar.gz"
  sha256 "88abf58ee5d7882e4cc3fa2462865ebbf0e8f872fdcec5186abe16e7bff3d4a5"
  license "BSD-3-Clause"

  livecheck do
    url "https://github.com/tessus/apachetop.git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0bd9b86d7e7a88136da835fd1e4bc715c2d98c097ab1956f8c3492eb557bc9b1"
    sha256 cellar: :any,                 arm64_big_sur:  "b3795c0b43fb378f2293b0f267468fc57e15dd34410786b35dc37bf9fbd075c5"
    sha256 cellar: :any,                 monterey:       "20984a6baad28aa3cfc47287b0682432f567de700c40ba6784835f9826b09761"
    sha256 cellar: :any,                 big_sur:        "23a71292dbcbdee0619bab39a416257fc0226c4ca5c942e23d373c13c0c237c1"
    sha256 cellar: :any,                 catalina:       "da48ab193d519f9a3ce1f90d1f6b4f4b9adee43a6a57435329d7a04e2a27e154"
    sha256 cellar: :any,                 mojave:         "a71dffc1d92dad7331f5e935395a20bb3ba953889f5083e92bcd7e4388a71ab5"
    sha256 cellar: :any,                 high_sierra:    "1bab24050249ddcf4f69b48b6568cf8e0464722d1a91cf3c1b6a21da0fdf4462"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "180b03f3d6507d52737f6a4490e9cbd870b10526bd1924191263c3785bbbb9ca"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "adns"
  depends_on "ncurses"
  depends_on "pcre"

  on_linux do
    depends_on "readline"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-logfile=/var/log/apache2/access_log",
                          "--with-adns=#{Formula["adns"].opt_prefix}",
                          "--with-pcre=#{Formula["pcre"].opt_prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/apachetop -h 2>&1", 1)
    assert_match "ApacheTop v#{version}", output
  end
end
