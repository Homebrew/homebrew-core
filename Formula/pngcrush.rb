class Pngcrush < Formula
  desc "Optimizer for PNG files"
  homepage "http://pmt.sourceforge.net/pngcrush/"
  url "https://downloads.sourceforge.net/project/pmt/pngcrush/1.8.7/pngcrush-1.8.7.tar.gz"
  sha256 "a1bc05b2847492afd1fc53d9797d2c99581567ffab59296f613b07586ffc75f2"

  bottle do
    cellar :any_skip_relocation
    sha256 "b6c671d45d99d6977faefca33d4346d37db5b644cf74fbde82ba353b1337d096" => :sierra
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
