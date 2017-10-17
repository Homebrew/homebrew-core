class Bro < Formula
  desc "Network security monitor"
  homepage "https://www.bro.org"
  url "https://www.bro.org/downloads/bro-2.5.2.tar.gz"
  sha256 "ab95b1bc376282919e5fa6b25b5ef8864e2e7bd5efe842db35d4a223b8f5b970"
  head "https://github.com/bro/bro.git"

  bottle do
    sha256 "c1e0af36971bd4173628f72d934bfe1c97e0ef76662625e0a3cb9bdd75441127" => :high_sierra
    sha256 "05c770a1f0980608c83d162c339a93b79fba28030034c5a76b918d37282c2d8f" => :sierra
    sha256 "3569f5e780b94a799ef4813fc1d02de35cedbc83117f5fd76babe4f3ef1476b5" => :el_capitan
    sha256 "c2db0c9f588606714e35ae577d44a27858da0d69233c50dc9b23ed1a1a205fb3" => :yosemite
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
