class Libmemcached < Formula
  desc "C and C++ client library to the memcached server"
  homepage "http://libmemcached.org/"
  url "https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz"
  sha256 "e22c0bb032fde08f53de9ffbc5a128233041d9f33b5de022c0978a2149885f82"
  revision 2

  bottle do
    cellar :any
    sha256 "f0fc1410caf2e9bfa130c52758a3d3a98a34032fe3d37a20980ab219042b6487" => :sierra
    sha256 "7b2540dda66e3de1be0603aafa10a18a006768f698a7db289c380235dad109a3" => :el_capitan
    sha256 "4e7e0cfb8f4d8f31e36c23b545ad3b0153c2f6d99645abf603f7e9f1ed427296" => :yosemite
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
