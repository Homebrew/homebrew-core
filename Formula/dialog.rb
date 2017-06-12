class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "http://invisible-island.net/dialog/"
  url "ftp://invisible-island.net/dialog/dialog-1.3-20170509.tgz"
  mirror "https://fossies.org/linux/misc/dialog-1.3-20170509.tgz"
  sha256 "2ff1ba74c632b9d13a0d0d2c942295dd4e8909694eeeded7908a467d0bcd4756"

  bottle do
    cellar :any_skip_relocation
    sha256 "15f85afce2306e17031370299bb97cdf2a6f8ede915fd2c19d8bb06847dbacdd" => :sierra
    sha256 "6042c7e4b069367cb607c97708eb097207f37230d7bc22fbc4e0924e20d134b3" => :el_capitan
    sha256 "3a5f37ec2481464ee96e383d619f1f28c14ed0b30645df91c1768dc6825592cf" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install-full"
  end

  test do
    system "#{bin}/dialog", "--version"
  end
end
