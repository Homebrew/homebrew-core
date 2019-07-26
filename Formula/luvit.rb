class Luvit < Formula
  desc "Asynchronous I/O for Lua"
  homepage "https://luvit.io"
  url "https://github.com/luvit/luvit/archive/2.16.0.tar.gz"
  sha256 "3cbd5136da6dba4ccfaee86357255c39b5fafa5fffa62d7d793514fa4dca1a79"
  head "https://github.com/luvit/luvit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a7a03a64fe8644ad9a0f6ae5b3695b541a34c8965e27d25e4d502052c6e60a5d" => :mojave
    sha256 "c3e8ffa00996e69f69959a6d245658e26f7f1347644fbd4c560495fff13b1e35" => :high_sierra
    sha256 "c3e8ffa00996e69f69959a6d245658e26f7f1347644fbd4c560495fff13b1e35" => :sierra
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
    assert_equal "Hello World\n", shell_output("#{bin}/luvit -e 'print(\"Hello World\")'")
  end
end
