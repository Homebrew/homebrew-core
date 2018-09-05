class Mp3val < Formula
  desc "Program for MPEG audio stream validation"
  homepage "https://mp3val.sourceforge.io/"
  url "https://downloads.sourceforge.net/mp3val/mp3val-0.1.8-src.tar.gz"
  sha256 "95a16efe3c352bb31d23d68ee5cb8bb8ebd9868d3dcf0d84c96864f80c31c39f"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ca5fe184a5427aea0df6910d654955c162268f803c1c372d11dd2305ad67513" => :mojave
    sha256 "f17a5c03d59e7665d2b85db559561a3375ff03a6e02911514a0adde35e188a06" => :high_sierra
    sha256 "649cf78ba7bc387f346a6685b8c83bec495a5e75ea0fa6d93135cc36ec898f5f" => :sierra
    sha256 "d13a9b31c885d1704a0cc5e1ff6b995acd616248abcf5276fc068b78f7be785f" => :el_capitan
    sha256 "298b6b2835de5f1aa3cef2f9435da3935ffbcfa49468511676661e8eaff8ca70" => :yosemite
    sha256 "0828eb9f4e02af5014e1b8d82be9ad54797b0de6a299b05a1ef0daa86bc5dbe2" => :mavericks
    sha256 "d90878cb83b0154dabc0cc03e61c3c972dec3ca66b63272716299f3b6dd791f7" => :mountain_lion
  end

  def install
    system "gnumake", "-f", "Makefile.gcc"
    bin.install "mp3val.exe" => "mp3val"
  end

  test do
    mp3 = test_fixtures("test.mp3")
    assert_match(/Done!$/, shell_output("#{bin}/mp3val -f #{mp3}"))
  end
end
