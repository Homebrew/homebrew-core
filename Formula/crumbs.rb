class Crumbs < Formula
  desc "Command-line bookmarking system for sh like consoles"
  homepage "https://github.com/fasseg/crumbs"
  url "https://github.com/fasseg/crumbs/archive/0.0.1.tar.gz"
  sha256 "5a799dbde93b7eb51050380c46a96e08547169b2642689b0a921bff687bc80fc"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/crumbs", "--help"
  end
end
