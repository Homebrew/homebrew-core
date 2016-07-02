class Luvit < Formula
  desc "Asynchronous I/O for Lua"
  homepage "https://luvit.io"
  url "https://github.com/luvit/luvit/archive/2.11.4.tar.gz"
  sha256 "47006628072eec9d09266d951184330509fa45ad76ac98d459667d8d1d2c32f0"
  head "https://github.com/luvit/luvit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac8ed1471899c4577232344ff5fad5f4e95797aff674efcd471d6e4ad78b8343" => :el_capitan
    sha256 "4833c6be863a8b31416e245030d827fe61d024ca953776efd7f550600484e6e7" => :yosemite
    sha256 "394aa23c5e37117c8a95c852f6ec24d7d4bb0be1cdd38d9f780e93bd7a990104" => :mavericks
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
