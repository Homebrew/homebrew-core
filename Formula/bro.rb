class Bro < Formula
  desc "Network security monitor"
  homepage "https://www.bro.org"
  url "https://www.bro.org/downloads/bro-2.5.3.tar.gz"
  sha256 "7384fa14e6cebc86488040877fc0bfd50868e969f0fa05178cef0116e4116225"
  head "https://github.com/bro/bro.git"

  bottle do
    sha256 "d2757caf4700fb383155632a1527be1236d63a46bf0a218d13cbbc9d1350826a" => :high_sierra
    sha256 "218b72b231601661166910e3c01ed08c9a9ace421df8f5131a136deb8b860b36" => :sierra
    sha256 "b70f3ee0e394543e0318a7af42d751a4568f0c3674f83b30d5003eb8961b34d1" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "openssl"
  depends_on "geoip" => :recommended

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}",
                          "--localstatedir=#{var}",
                          "--conf-files-dir=#{etc}"
    system "make", "install"
  end

  test do
    system "#{bin}/bro", "--version"
  end
end
