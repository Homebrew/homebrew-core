class Pngcrush < Formula
  desc "Optimizer for PNG files"
  homepage "http://pmt.sourceforge.net/pngcrush/"
  url "https://downloads.sourceforge.net/project/pmt/pngcrush/1.8.1/pngcrush-1.8.1.tar.gz"
  sha256 "ab299feb0dd77d2e84a043cf773302ad6323733d9b82e8ce76468dd024c0ad63"

  bottle do
    cellar :any_skip_relocation
    sha256 "a75f6377dc6c8e62b295c8a6d9f31b739000163d26305d2cc05f70a1b64a463c" => :el_capitan
    sha256 "53e91f6cbfabad1425d2145b8c47eddedfe2b73ad6fb06e2b71b4bf5cec5cb18" => :yosemite
    sha256 "8be510524955d73e569446268ac2dcde02660ada3df9d8575d8914eb44e556e8" => :mavericks
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
