class Direvent < Formula
  desc "Monitors events in the file system directories"
  homepage "http://www.gnu.org.ua/software/direvent/direvent.html"
  url "https://ftp.gnu.org/gnu/direvent/direvent-5.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/direvent/direvent-5.1.tar.gz"
  sha256 "c461600d24183563a4ea47c2fd806037a43354ea68014646b424ac797a959bdb"

  bottle do
    sha256 "9bc340296e903dd37848907cd76ce5a67c74e78076ef615ff824617ff0d37db8" => :sierra
    sha256 "0d9c0063931a3dc02e5c24742bfb85fc173b3bec6f31771507aa1b48c892138d" => :el_capitan
    sha256 "0158e3fe5a0401cb87ef6b2cad4915887f22ce6ffcbf93a2f19c7a659be1f0a7" => :yosemite
    sha256 "7f8fc5e86deb4b518645bf10772183d100389c2e9bbf9b7f2c1559276d1fcbf0" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/direvent --version")
  end
end
