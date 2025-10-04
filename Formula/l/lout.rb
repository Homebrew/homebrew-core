class Lout < Formula
  desc "Text formatting like TeX, but simpler"
  homepage "https://savannah.nongnu.org/projects/lout"
  url "https://github.com/william8000/lout/archive/refs/tags/3.43.2.tar.gz"
  sha256 "11a3185ec7a5c454ee2e3b907bbb6045657b6ff09a6a4a41f6adb5abca66cf99"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "3eb773b1adf3a54b55d673180c0f5738c9287f7180ce686f5bcf2d1847203752"
    sha256 arm64_sequoia: "86e217e1e33434d7a135a9c8802ef9880865e34599e1a0c0896b6a8c464e43c0"
    sha256 arm64_sonoma:  "465073cddb4d8234da894a169f4460c4e8ab15f63b06c3cd721ed4f44fd2191c"
    sha256 arm64_ventura: "29ce8e8fa28334dff18b7d739f556dcfc32bdc3fd88938eff874bc0b9a8759d7"
    sha256 sonoma:        "75db1424724cd0fd9c3ed19ade2fdc3ab4958c23649bd8dc7f7af27f79cde4fb"
    sha256 ventura:       "9e34eb97e834865686d15773aa2419fd53dd4cbb95c64cdd05ab95c561b70a7e"
    sha256 arm64_linux:   "b8cf9969487d8a01a1849de861bfa63c8a931f0394fbcf09ceb283a43999556b"
    sha256 x86_64_linux:  "f30fc0a33cdbabab590e4f44f95046ebf7be63db9db77db97a4641ae20277c72"
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
