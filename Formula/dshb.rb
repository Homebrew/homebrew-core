class Dshb < Formula
  desc "macOS system monitor in Swift"
  homepage "https://github.com/beltex/dshb"
  url "https://github.com/beltex/dshb/releases/download/v0.2.0/dshb-0.2.0-source.zip"
  sha256 "b2d512e743d2973ae4cddfead2c5b251c45e5f5d64baff0955bee88e94035c33"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, mojave:      "f909f0128ee08e47f8cfdc25af26ba648c537cc07348a8b401871bcd23735fae"
    sha256 cellar: :any_skip_relocation, high_sierra: "486fe71444a4a07f3e7a20a0deab2e4029a927514ae70f563ff89b72db44a263"
    sha256 cellar: :any_skip_relocation, sierra:      "486fe71444a4a07f3e7a20a0deab2e4029a927514ae70f563ff89b72db44a263"
    sha256 cellar: :any_skip_relocation, el_capitan:  "e0aa0f64ac02e9244fc59773a966d1ac5755dc4a4c91c0dbcd92633c4330f14b"
  end

  disable! date: "2020-12-08", because: :unmaintained

  depends_on xcode: ["8.0", :build]

  def install
    system "make", "release"
    bin.install "bin/dshb"
    man1.install "docs/dshb.1"
  end

  test do
    pipe_output("#{bin}/dshb", "q", 0)
  end
end
