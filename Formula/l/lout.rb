class Lout < Formula
  desc "Text formatting like TeX, but simpler"
  homepage "https://savannah.nongnu.org/projects/lout"
  url "https://github.com/william8000/lout/archive/refs/tags/3.43.1.tar.gz"
  sha256 "e18e220d69726f1375164334107bc33237f05bd82a6d8ff11741bebdee924540"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "e9ed13c897900b56cba3a52f2fa83d11e6868917ca964b6aad735df9ddc72c19"
    sha256 arm64_sonoma:  "db75b1eb4376ba587377030f1c154a1c5dc1026c3e69ccf7f3f4bca310ab09d2"
    sha256 arm64_ventura: "36d4dbcfb60cd3e34ef95b0149b63c95d0f6c80d3a1f091077f2099dc6d059c0"
    sha256 sonoma:        "557fabce8567fc87281e2fca29f967ba46a52e99e30263a37dfd106eb41505e4"
    sha256 ventura:       "2fdb333adee5e2d4c51b1357b60887993cebb74c00e6ec90dbff285ba7e11b29"
    sha256 arm64_linux:   "ab6bc86fa05d9dc8246468b734aaeebf39cd8ecb2d023e5affc0a742fc225c51"
    sha256 x86_64_linux:  "4066e6e926425dd434b6f48343e4cdf8a8a0e1ecf54638f16d483aeda4183b26"
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
