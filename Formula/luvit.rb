class Luvit < Formula
  desc "Asynchronous I/O for Lua"
  homepage "https://luvit.io"
  url "https://github.com/luvit/luvit/archive/2.16.0.tar.gz"
  sha256 "3cbd5136da6dba4ccfaee86357255c39b5fafa5fffa62d7d793514fa4dca1a79"
  revision 1
  head "https://github.com/luvit/luvit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "62c97a3fcfb29db0e0665c2b26ffc44c15a46982786bb9bf6a5f1a5cbda8c68b" => :mojave
    sha256 "62c97a3fcfb29db0e0665c2b26ffc44c15a46982786bb9bf6a5f1a5cbda8c68b" => :high_sierra
    sha256 "1e2609744391676a48798b34a567c54eaf1f4dbd237968e6dc419e2eb67d404a" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "luajit"
  depends_on "openssl@1.1"

  def install
    ENV["USE_SYSTEM_SSL"] = "1"
    ENV["USE_SYSTEM_LUAJIT"] = "1"
    ENV["PREFIX"] = prefix
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "Hello World\n", shell_output("#{bin}/luvit -e 'print(\"Hello World\")'")
  end
end
