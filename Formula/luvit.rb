class Luvit < Formula
  desc "Asynchronous I/O for Lua"
  homepage "https://luvit.io"
  url "https://github.com/luvit/luvit/archive/2.12.0.tar.gz"
  sha256 "8f170b9664192d13dd156ea3c3cc663b5591b2e2641aad4c2463b4207a9e4868"
  head "https://github.com/luvit/luvit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "24a0ed5e35605d0dc0059c078a99652d9806529e9a27f96d075b726cebd37d0b" => :sierra
    sha256 "2c698a4535fc0fe575a1f114e16ada44baaa19fe2ed91c2f18d6d74b586a5fdd" => :el_capitan
    sha256 "2c698a4535fc0fe575a1f114e16ada44baaa19fe2ed91c2f18d6d74b586a5fdd" => :yosemite
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
