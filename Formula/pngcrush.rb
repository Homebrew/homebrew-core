class Pngcrush < Formula
  desc "Optimizer for PNG files"
  homepage "http://pmt.sourceforge.net/pngcrush/"
  url "https://downloads.sourceforge.net/project/pmt/pngcrush/1.8.10/pngcrush-1.8.10.tar.gz"
  sha256 "ed8dc4759d5067ebf53a2a5188eff1e8ad10262737cf50516cccf8c60d220b6d"

  bottle do
    cellar :any_skip_relocation
    sha256 "76204e797331ce2d454a0781296d122628acc9cb631fadaaac4b90c6e0f36932" => :sierra
    sha256 "e82a9b969438a5434be036ff922b0df563b64e070548921a1a9e3538b9df80ec" => :el_capitan
    sha256 "07ceca9ffb572a78d036aad41cb612b963ba86e8b16008e85110ca3fc7650a94" => :yosemite
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
