class Dshb < Formula
  desc "macOS system monitor in Swift"
  homepage "https://github.com/beltex/dshb"
  url "https://github.com/beltex/dshb/releases/download/v0.2.0/dshb-0.2.0-source.zip"
  sha256 "b2d512e743d2973ae4cddfead2c5b251c45e5f5d64baff0955bee88e94035c33"

  bottle do
    cellar :any_skip_relocation
    sha256 "f909f0128ee08e47f8cfdc25af26ba648c537cc07348a8b401871bcd23735fae" => :mojave
    sha256 "486fe71444a4a07f3e7a20a0deab2e4029a927514ae70f563ff89b72db44a263" => :high_sierra
    sha256 "486fe71444a4a07f3e7a20a0deab2e4029a927514ae70f563ff89b72db44a263" => :sierra
    sha256 "e0aa0f64ac02e9244fc59773a966d1ac5755dc4a4c91c0dbcd92633c4330f14b" => :el_capitan
  end

  depends_on :xcode => ["8.0", :build]

  def install
    system "make", "release"
    bin.install "bin/dshb"
    man1.install "docs/dshb.1"
  end

  test do
    pipe_output("#{bin}/dshb", "q", 0)
  end
end
