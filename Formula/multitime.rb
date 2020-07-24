class Multitime < Formula
  desc "Multitime: a better time utility"
  homepage "https://tratt.net/laurie/src/multitime/"
  url "https://github.com/ltratt/multitime/archive/multitime-1.4.tar.gz"
  sha256 "31597066239896ee74a3aaaea3b22931a50a1ec1470090c5457ef35500c44249"
  license "MIT"

  depends_on "autoconf" => :build

  def install
    system "autoconf"
    system "autoheader"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    man1.install "multitime.1"
  end

  test do
    system "#{bin}/multitime", "-n", "2", "sleep", "1"
  end
end
