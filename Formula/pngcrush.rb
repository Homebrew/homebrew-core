class Pngcrush < Formula
  desc "Optimizer for PNG files"
  homepage "https://pmt.sourceforge.io/pngcrush"
  url "https://downloads.sourceforge.net/project/pmt/pngcrush/1.8.13/pngcrush-1.8.13.tar.xz"
  sha256 "8fc18bcbcc65146769241e20f9e21e443b0f4538d581250dce89b1e969a30705"

  bottle do
    cellar :any_skip_relocation
    sha256 "69ba01bc2bdd7de877e6463c8d4b6c877e618ba27dc2eb91524b61a15631fd28" => :sierra
    sha256 "cc4ff10c5988d6e39f2a6c7131f772bd919959216a71c612f44792372f1ad127" => :el_capitan
    sha256 "67a4b77fa27efbf2625b2923d955fcf8a16211a311cb6806f034ff07d1522d5c" => :yosemite
  end

  def install
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
