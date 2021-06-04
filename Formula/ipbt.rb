class Ipbt < Formula
  desc "Program for recording a UNIX terminal session"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/ipbt-20210215.5a9cb02.tar.gz"
  version "20210215"
  sha256 "0aeafaacbccb89d2aaf044d6c6582c71cb66f607847854f2df514a21f6a5cb70"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?ipbt[._-]v?(\d+(?:\.\d+)*)(?:[._-][\da-z]+)?\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "78f292ac5378f3b8d1a9bb5260a60a3b40118b944edcdaaca912646407e42d5d"
    sha256 cellar: :any_skip_relocation, big_sur:       "66c701400fe87ae661d959bb9f7558f7658c5d81e71438ec76435ee2943329aa"
    sha256 cellar: :any_skip_relocation, catalina:      "f08bb4d0b1710cb02f1960c229f137c44505980793251ab81d0222be5f1b61e7"
    sha256 cellar: :any_skip_relocation, mojave:        "5678b11877df9433ceb47661596d3f0b4d0894e44a4173ae118b746117938e59"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system "#{bin}/ipbt"
  end
end
