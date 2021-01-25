class Luit < Formula
  desc "Filter run between arbitrary application and UTF-8 terminal emulator"
  homepage "https://invisible-island.net/luit/"
  url "https://invisible-mirror.net/archives/luit/luit-20201003.tgz"
  sha256 "c948da3c8b163e8e8f23cbe1255e7f3fa234c48aaf470b201ce55a3ecb4ad985"
  license "MIT"

  livecheck do
    url "https://invisible-mirror.net/archives/luit/"
    regex(/href=.*?luit[._-]v?(\d+(?:[.-]\d+)*)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "15a8a5131d2751a372eb1304cff89af4a0437255de8b35221611021cb810d6b9" => :big_sur
    sha256 "95869407113a13608e1c8063775f3a43d5c4f43d68a32179d2b0b7e6b4ef24d5" => :arm64_big_sur
    sha256 "a26f38e63953d9107400fc4ba2bf66216041aaa76cffb69dfc975c03327b2850" => :catalina
    sha256 "6e8560fb5defe523bce78f14e02a1dc46388c1b39755cb1ae6eedc9d6ea24738" => :mojave
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--without-x"
    system "make", "install"
  end

  test do
    require "pty"
    (testpath/"input").write("#end {bye}\n")
    PTY.spawn(bin/"luit", "-encoding", "GBK", "echo", "foobar") do |r, _w, _pid|
      assert_match "foobar", r.read
    end
  end
end
