class Luvit < Formula
  desc "Asynchronous I/O for Lua"
  homepage "https://luvit.io"
  url "https://github.com/luvit/luvit/archive/2.14.2.tar.gz"
  sha256 "6554eb329ef1d678c601041743d865f3e698abeb164d4783bba4cdc379cc7faf"
  head "https://github.com/luvit/luvit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c755b81462d5a91456cc3b27aad71a77c5c9c51693f2e7998df2cceaaafcdec" => :sierra
    sha256 "3876f660f6ada25b6d0eb8d7a65e2d771a50f6f90b2c92f583ecb398680d5421" => :el_capitan
    sha256 "3876f660f6ada25b6d0eb8d7a65e2d771a50f6f90b2c92f583ecb398680d5421" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "luajit"
  depends_on "openssl"

  def install
    ENV["USE_SYSTEM_SSL"] = "1"
    ENV["USE_SYSTEM_LUAJIT"] = "1"
    ENV["PREFIX"] = prefix
    system "make"
    system "make", "install"
  end

  test do
    system bin/"luvit", "--cflags", "--libs"
  end
end
