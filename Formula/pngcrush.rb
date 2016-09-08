class Pngcrush < Formula
  desc "Optimizer for PNG files"
  homepage "http://pmt.sourceforge.net/pngcrush/"
  url "https://downloads.sourceforge.net/project/pmt/pngcrush/1.8.6/pngcrush-1.8.6.tar.gz"
  sha256 "6cea4a981f0e953c8f3af8b20964f1f106aaf22c63d2d49e8a503ebfd248b85c"

  bottle do
    cellar :any_skip_relocation
    sha256 "c4ed270d22feeb48689542d44dd3225cca13d27657e147a0aa6220027c55be07" => :el_capitan
    sha256 "bf46beae36a0ad019b9d6c5a676612b45aab99dc4d28273c74b980dcd00fe10b" => :yosemite
    sha256 "ed228209fe5e22d1c298843852987649818dbc9e0f00b93165f608a2c650a7e1" => :mavericks
  end

  def install
    # Required to enable "-cc" (color counting) option (disabled by default
    # since 1.5.1)
    ENV.append_to_cflags "-DPNGCRUSH_COUNT_COLORS"

    system "make", "CC=#{ENV.cc}",
                   "LD=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=#{ENV.ldflags}"
    bin.install "pngcrush"
  end

  test do
    system "#{bin}/pngcrush", test_fixtures("test.png"), "/dev/null"
  end
end
