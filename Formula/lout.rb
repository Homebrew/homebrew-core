class Lout < Formula
  desc "Text formatting like TeX, but simpler"
  homepage "https://savannah.nongnu.org/projects/lout"
  url "https://github.com/william8000/lout/archive/refs/tags/3.42.2.tar.gz"
  sha256 "521fcbf9368b248015eac4a836067a68d604949fd29c8ee269159f18d44f8d98"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "8c410ce3f37c6f9c3bdb3242221be764c0088527fb04e0d2162e7cf6d3da7d47"
    sha256 arm64_monterey: "4f441eb3dae5b3177b2fa97c45560052388a01ef190d7a4a5e6de0d10fe3c20a"
    sha256 arm64_big_sur:  "8a88cbdcd832cd802454a7895e9ddee449ce5c221237e85ea8352b11b2907593"
    sha256 ventura:        "688f5d95ead102ea669a7c795f60d4ce4b6f461581f3ed52ef5d0d98b23884d0"
    sha256 monterey:       "b0d5caf6b3f0f11c78b0ca20e07371be67e417119c8801e406819c6b191bcb89"
    sha256 big_sur:        "6f854396e27fcde9548e2134aa5ee807050d2575134a80c0fc8250312399e736"
    sha256 catalina:       "30fee71b8a0dff7b5b189734fb23f6d1cc7e8919f88ea88e142a7f6b3c047352"
    sha256 x86_64_linux:   "339d1a881b67599feaa47478c743ea32be1536b2b4361b1a3947c10779291e03"
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
