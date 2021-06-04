class Gsar < Formula
  desc "General Search And Replace on files"
  homepage "http://tjaberg.com/"
  url "http://tjaberg.com/gsar121.zip"
  version "1.21"
  sha256 "05fb9583c970aba4eb0ffae2763d7482b0697c65fda1632a247a0153d7db65a9"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "422050c4abb86641242bd8649dc39b83bf9a0bff0b2f57c0011d59baefaa87ac"
    sha256 cellar: :any_skip_relocation, big_sur:       "ae21f0b2eb41982c4c78ad3fdf0aab16e839a40761d7e98e31ce6f3f52e3fa9c"
    sha256 cellar: :any_skip_relocation, catalina:      "be008a03610074b4c66f775ae1802ed214006e6ba21150da886c8f4aa97362a4"
    sha256 cellar: :any_skip_relocation, mojave:        "b357c58535d31278d9b815770aa10e9f7d496849ecf58e131a23ea2182c7cbc3"
    sha256 cellar: :any_skip_relocation, high_sierra:   "07872ab6e21c22fe0ff901974ff6772d934bebc6f574a8908e6e3600a0fb6fb9"
    sha256 cellar: :any_skip_relocation, sierra:        "762262cc0840aa074588b1fbbd534f6b865a44d344628b9dbf36b07dfdef2a9a"
    sha256 cellar: :any_skip_relocation, el_capitan:    "5cf3fe6d772f95378e2802a6208b8f06524a81b4d881343571dd3af201b69e98"
    sha256 cellar: :any_skip_relocation, yosemite:      "6e138e63b868dfbd4d16109cabe60f50dc600fd65cbf14cd3926b1b8c2f3e2dc"
  end

  def install
    system "make"
    bin.install "gsar"
  end

  test do
    assert_match "1 occurrence changed",
      shell_output("#{bin}/gsar -sCourier -rMonaco #{test_fixtures("test.ps")} new.ps")
  end
end
