class Luvit < Formula
  desc "Asynchronous I/O for Lua"
  homepage "https://luvit.io"
  url "https://github.com/luvit/luvit/archive/2.14.1.tar.gz"
  sha256 "24678b1388eae19d0e48b7df6c35635383528f383e8557928c74b4d397935fb2"
  head "https://github.com/luvit/luvit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3b25013012238e673c293e2ae2aef3e39c8b3675a2effdfdef8eb146e9423bf1" => :sierra
    sha256 "45d4d6d2a76de4ad1c7c05378fa1cfaa2383c16e33bd95c2a79a8a2315f3ac82" => :el_capitan
    sha256 "45d4d6d2a76de4ad1c7c05378fa1cfaa2383c16e33bd95c2a79a8a2315f3ac82" => :yosemite
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
