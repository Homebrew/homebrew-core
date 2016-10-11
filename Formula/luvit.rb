class Luvit < Formula
  desc "Asynchronous I/O for Lua"
  homepage "https://luvit.io"
  url "https://github.com/luvit/luvit/archive/2.11.5.tar.gz"
  sha256 "953fceb4980eafe16f54d1316f12baac9f1ed913764fed28c3f178cceb026046"
  head "https://github.com/luvit/luvit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e105e74d17f2e7f0322116f7336a3df4a68685104981f456d01879079f68ece" => :sierra
    sha256 "728882f240f666b5b04458206af37e4e84d9d656c8918c657f61b4fcb1d29188" => :el_capitan
    sha256 "7dd6c06c1bec92c22d957663a27ece45eb9ce10edb11a4c1f87ba8a78f245b56" => :yosemite
    sha256 "66ad68f41d253bab1197f1b8445e254ae587ded4a5d0b9af554b55d4a7179c34" => :mavericks
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
