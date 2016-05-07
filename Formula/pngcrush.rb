class Pngcrush < Formula
  desc "Optimizer for PNG files"
  homepage "http://pmt.sourceforge.net/pngcrush/"
  url "https://downloads.sourceforge.net/project/pmt/pngcrush/1.8.1/pngcrush-1.8.1.tar.gz"
  sha256 "ab299feb0dd77d2e84a043cf773302ad6323733d9b82e8ce76468dd024c0ad63"

  bottle do
    cellar :any_skip_relocation
    sha256 "32f5cb6c44a139caac47b9f062b7431072b6a2e9d8247af76ce0f1165d6bde01" => :el_capitan
    sha256 "efa6ae085555837e4d7ed633e25210f94031ac959057ccd74f5763a1ca411abb" => :yosemite
    sha256 "e2277139c5e4e13bff2c5356469e400509e70d359cbf80d48e53c6fc0abb3731" => :mavericks
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
