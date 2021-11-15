class Mp3val < Formula
  desc "Program for MPEG audio stream validation"
  homepage "https://mp3val.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mp3val/mp3val/mp3val%200.1.8/mp3val-0.1.8-src.tar.gz"
  sha256 "95a16efe3c352bb31d23d68ee5cb8bb8ebd9868d3dcf0d84c96864f80c31c39f"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75d055d4fb5b3abc7ded7ad8e99011fc2e84cf0d8c24c01f1512941b17d3f02d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d5718fcb9967416eb3e3cf3e9a186e98bade6be099c57583b0d9dcc0fa43103"
    sha256 cellar: :any_skip_relocation, monterey:       "981e3b3fbb87bd417e50d947bb994049508ce850ffd432c9d3ae0306cf3e6182"
    sha256 cellar: :any_skip_relocation, big_sur:        "671ef59185d212e89c19dda72da09ef7a37e3055f4d42d188079f29122c641dc"
    sha256 cellar: :any_skip_relocation, catalina:       "c08b493f2f59730486c427b795112ea1c730fb9bb7dcbc0bc9158c2c28a30c51"
    sha256 cellar: :any_skip_relocation, mojave:         "4ca5fe184a5427aea0df6910d654955c162268f803c1c372d11dd2305ad67513"
    sha256 cellar: :any_skip_relocation, high_sierra:    "f17a5c03d59e7665d2b85db559561a3375ff03a6e02911514a0adde35e188a06"
    sha256 cellar: :any_skip_relocation, sierra:         "649cf78ba7bc387f346a6685b8c83bec495a5e75ea0fa6d93135cc36ec898f5f"
    sha256 cellar: :any_skip_relocation, el_capitan:     "d13a9b31c885d1704a0cc5e1ff6b995acd616248abcf5276fc068b78f7be785f"
    sha256 cellar: :any_skip_relocation, yosemite:       "298b6b2835de5f1aa3cef2f9435da3935ffbcfa49468511676661e8eaff8ca70"
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
