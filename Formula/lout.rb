class Lout < Formula
  desc "Text formatting like TeX, but simpler"
  homepage "https://savannah.nongnu.org/projects/lout"
  url "https://github.com/william8000/lout/archive/refs/tags/3.42.1.tar.gz"
  sha256 "b0b2f66a0f959bc80835966c69ae4d4eef2cb0def2b03e634bf1c7e55b1fe6dd"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "63e654e4a8a80650fd93e7753b02324fadf155859ed2033eefb86ff1e197d1c2"
    sha256 arm64_big_sur:  "e582d850d93ad8ce569374f5154598dc0a0f4b96d99406cba59192765c7bb825"
    sha256 monterey:       "58484f4b661d7717a51d040b24c5e713f2338b4f64ac9e9bb553ad1801df0ad0"
    sha256 big_sur:        "9bd926fea1d826e067041b86414ef4b8fbe46db5a2ed56d0a4416be908c87d09"
    sha256 catalina:       "600c4e098a6b6b72ea3b55d3e6c4ce2369181c1292f4529e14ab43a336eaccfb"
    sha256 x86_64_linux:   "2f1be7368fbe1290b5c8e1751ad56ab8291b9369fa67c11d6ef999b51516f3a7"
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
