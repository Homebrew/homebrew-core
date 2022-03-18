class Lout < Formula
  desc "Text formatting like TeX, but simpler"
  homepage "https://savannah.nongnu.org/projects/lout"
  url "https://github.com/william8000/lout/archive/refs/tags/3.42.1.tar.gz"
  sha256 "b0b2f66a0f959bc80835966c69ae4d4eef2cb0def2b03e634bf1c7e55b1fe6dd"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "3a87b31938c939e6462d9ac00da2d3763fc2559c82b52141260ab4e8f94e0dee"
    sha256 arm64_big_sur:  "83b6f34bde01cfc2a8aa909d5e68dba9427c9bd1700859c83d0b57e4e8567dfd"
    sha256 monterey:       "2fa62e7fb290e445eea34f2a7d8db547f0a8cacfd6b8189e277a3fc34586f293"
    sha256 big_sur:        "890eb00501a3a7cf541dd546fd601b37a6d4e7500cff774db1889b8b5161a2fc"
    sha256 catalina:       "16763515f05d7c6020a3b7a49e8ccac80c90363a792d3bc2d554f61f4f8e1a10"
    sha256 x86_64_linux:   "f76b5af425172f298d3f79cd56ae6a2d74d67c2990c4951e52bcdc2b57cdc1f0"
  end

  def install
    bin.mkpath
    man1.mkpath
    (doc/"lout").mkpath
    system "make", "PREFIX=#{prefix}", "LOUTLIBDIR=#{lib}", "LOUTDOCDIR=#{doc}", "MANDIR=#{man}", "allinstall"
  end

  test do
    input = "test.lout"
    (testpath/input).write <<~EOS
      @SysInclude { doc }
      @Doc @Text @Begin
      @Display @Heading { Blindtext }
      The quick brown fox jumps over the lazy dog.
      @End @Text
    EOS
    assert_match(/^\s+Blindtext\s+The quick brown fox.*\n+$/, shell_output("#{bin}/lout -p #{input}"))
  end
end
