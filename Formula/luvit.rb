class Luvit < Formula
  desc "Asynchronous I/O for Lua"
  homepage "https://luvit.io"
  url "https://github.com/luvit/luvit/archive/2.11.5.tar.gz"
  sha256 "953fceb4980eafe16f54d1316f12baac9f1ed913764fed28c3f178cceb026046"
  head "https://github.com/luvit/luvit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8ca70b8c0861cb06e02760c2d01b3f349efacae90f5126fa14b3bc2bcd2dc5cf" => :el_capitan
    sha256 "73805345874d625f09dab21027c018495eabb469246f835e9b0e9417dffcbace" => :yosemite
    sha256 "4ba9259d1bf2af8d15f1d62b084aa486d86f2c4380c3bf92a2186591f8ea31f3" => :mavericks
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
