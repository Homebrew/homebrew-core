class Luit < Formula
  desc "Filter run between arbitrary application and UTF-8 terminal emulator"
  homepage "https://invisible-island.net/luit/"
  url "https://invisible-mirror.net/archives/luit/luit-20221028.tgz"
  sha256 "ef78b3a64a697cb70a881558abb8251e4b30748ceefb8d44adbd8ea797bcfca6"
  license "MIT"

  livecheck do
    url "https://invisible-mirror.net/archives/luit/"
    regex(/href=.*?luit[._-]v?(\d+(?:[.-]\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "132aa18b60949dd628c7a8476df562c4fa04f88ead32f08cec54182add165a5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91e3b521424f647de71dff1b4159a7fb841a94e733d784e39945998006ddb987"
    sha256 cellar: :any_skip_relocation, monterey:       "4f72da9571d474cecb82bc3f14041f2488be3821a2a1ed025aa22c6e35ae802c"
    sha256 cellar: :any_skip_relocation, big_sur:        "7945436cd68b2d7af9deed97cbf27c4a885f0340e7816e92c005774b6074de32"
    sha256 cellar: :any_skip_relocation, catalina:       "ca3df4772b8b9726d45906983fedd72464dcc04f884c9e1315b5982f3efac4f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d7f340c3f56ce265dfbcd8fdaa0824f4dc3e73e8baee2c8e3c634cd551acd67"
  end

  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}", "--without-x"
    system "make", "install"
  end

  test do
    require "pty"
    (testpath/"input").write("#end {bye}\n")
    PTY.spawn(bin/"luit", "-encoding", "GBK", "echo", "foobar") do |r, _w, _pid|
      assert_match "foobar", r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  end
end
