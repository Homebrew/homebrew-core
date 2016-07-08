class Direvent < Formula
  desc "Monitors events in the file system directories"
  homepage "http://www.gnu.org.ua/software/direvent/direvent.html"
  url "https://ftpmirror.gnu.org/direvent/direvent-5.1.tar.gz"
  sha256 "c461600d24183563a4ea47c2fd806037a43354ea68014646b424ac797a959bdb"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "-C", "tests", "check-local"
    system "make", "install"
  end

  test do
    system "#{bin}/direvent", "--version"
  end
end
