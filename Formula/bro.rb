class Bro < Formula
  desc "Network security monitor"
  homepage "https://www.bro.org"
  url "https://www.bro.org/downloads/bro-2.5.1.tar.gz"
  sha256 "2c6ce502864bee9323c3e46213a21cfe9281a65cbedf81d5ab6160a437a89511"
  head "https://github.com/bro/bro.git"

  bottle do
    sha256 "05c770a1f0980608c83d162c339a93b79fba28030034c5a76b918d37282c2d8f" => :sierra
    sha256 "3569f5e780b94a799ef4813fc1d02de35cedbc83117f5fd76babe4f3ef1476b5" => :el_capitan
    sha256 "c2db0c9f588606714e35ae577d44a27858da0d69233c50dc9b23ed1a1a205fb3" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "openssl"
  depends_on "geoip" => :recommended

  conflicts_with "brotli", :because => "Both install a `bro` binary"

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
