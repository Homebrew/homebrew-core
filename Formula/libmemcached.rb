class Libmemcached < Formula
  desc "C and C++ client library to the memcached server"
  homepage "http://libmemcached.org/"
  url "https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz"
  sha256 "e22c0bb032fde08f53de9ffbc5a128233041d9f33b5de022c0978a2149885f82"
  revision 2

  bottle do
    cellar :any
    sha256 "3ccc8ce08ad64df9952d800cf6d336c35f4083ad366e61c33586a1d932ef556a" => :sierra
    sha256 "a6714baf6c2451c8ef44616a999183bf2ad1d6dd6b837ece97324bbc97c7b800" => :el_capitan
    sha256 "726426f5a3fd386bbbe637935377e46cea6bd6ca24d086ecead5962de1ecdc33" => :yosemite
    sha256 "819a893ecb0d662b2cc299dcc5f86879b569f91a2101a4b3e1f3b265bacc2708" => :mavericks
    sha256 "bcf00c6004c5d4e5104867e16905f4375b129b527a47b2b000131bf59e15a423" => :mountain_lion
  end

  depends_on "memcached"

  # https://bugs.launchpad.net/libmemcached/+bug/1245562
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/60f3532/libmemcached/1.0.18.patch"
    sha256 "592f10fac729bd2a2b79df26086185d6e08f8667cb40153407c08d4478db89fb"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
