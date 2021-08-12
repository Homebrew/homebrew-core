class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  homepage "https://lnav.org/"
  url "https://github.com/tstack/lnav/releases/download/v0.10.0/lnav-0.10.0.tar.gz"
  sha256 "05caf14d410a3912ef9093773aec321e0f4718a29476005c05dd53fcd6de1531"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "6956716054ca3e613e95540a54a1fd8ef67ef3f4e51ce665e4b8d6c89636cc66"
    sha256 cellar: :any,                 big_sur:       "29b6a8e732ac1e65fc3007415d9485636073a2aa31317255b29911f4ffba04b9"
    sha256 cellar: :any,                 catalina:      "f01d5a0c1f1c2b8363d9955ff6fdda4f78ac78fede954935d2984bd8ddd9b15d"
    sha256 cellar: :any,                 mojave:        "09cdb7d5fd6f816cd8f69bf23e29ac4e9775186bfb959b533ef321bcb61d4395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1bebe74f8cc100795599682aed4658bd66821abcab88c92fadf6bf246cef28d"
  end

  head do
    url "https://github.com/tstack/lnav.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "re2c" => :build
  end

  depends_on "pcre"
  depends_on "readline"
  depends_on "sqlite"

  on_linux do
    depends_on "gcc" => :build
  end

  fails_with gcc: "5"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-sqlite=#{Formula["sqlite"].opt_prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/lnav", "-V"
  end
end
