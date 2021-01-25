class Clib < Formula
  desc "Package manager for C programming"
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/2.6.1.tar.gz"
  sha256 "2a130caa056aad2011896d376d2bfeedd11a3710b6f1d3fdecc6302a7d1e39cd"
  license "MIT"
  head "https://github.com/clibs/clib.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ab863f15a818566f933db178a2c174ca5ceea5f4dcac7134a48cfcf8489af04d" => :big_sur
    sha256 "5e278922b5073b3855686c1993943ac978bb80417c0ed7a083d5b82775011c37" => :arm64_big_sur
    sha256 "278095d11c8e7cf01dc41de774323d49746d0fcce23ea332277911f03310e6fc" => :catalina
    sha256 "903694121ada8b3ecc41ab0ba16054d41b410b5cd8290ac73d51cc60313db829" => :mojave
  end

  uses_from_macos "curl"

  def install
    ENV["PREFIX"] = prefix
    system "make", "install"
  end

  test do
    system "#{bin}/clib", "install", "stephenmathieson/rot13.c"
  end
end
