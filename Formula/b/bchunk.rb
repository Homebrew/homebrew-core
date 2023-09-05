class Bchunk < Formula
  desc "Convert CD images from .bin/.cue to .iso/.cdr"
  homepage "http://he.fi/bchunk/"
  url "http://he.fi/bchunk/bchunk-1.2.2.tar.gz"
  sha256 "e7d99b5b60ff0b94c540379f6396a670210400124544fb1af985dd3551eabd89"
  license "GPL-2.0"
  head "https://github.com/hessu/bchunk.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?bchunk[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "577174425847ab641ddbd3dd9001c596c2dbcc69ad54272c412a0d338c0ddd68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c361f431e4d301b9a0805db04d500f73c4247d06067aba3ec74944525bc7855c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94279b4e400c05770ec6c5cce6fe7ef50a062835508add3e981942944bb3eecc"
    sha256 cellar: :any_skip_relocation, ventura:        "ebb931a33718b6f6a70e94da300b4da3470664d00bd57d7b7856bf6449f61fe7"
    sha256 cellar: :any_skip_relocation, monterey:       "cbfaaf81653c53be4dbc62fe7eb6e13071ad9961b18d5f0369bd8f003cded841"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf3ec0f873db02e0234790bc8b700e4f1b989877742cf1560854e7b561698f4b"
    sha256 cellar: :any_skip_relocation, catalina:       "b9f7bc758711585d7a016b7b3ddefe3256a368c00b21c51691481c7fbfc2823a"
    sha256 cellar: :any_skip_relocation, mojave:         "232935a7e7291016af594df742848d851ceca12ff9c06e183485c6a184c1df38"
    sha256 cellar: :any_skip_relocation, high_sierra:    "d6183607b5b987345ee3380263819f1d5e12f2f3cc9f6fd55accfbf92c26d5ef"
    sha256 cellar: :any_skip_relocation, sierra:         "95ef5fddc2234902187dde834690fb5957bd99ce11403e3d0f8881a705bb8f27"
    sha256 cellar: :any_skip_relocation, el_capitan:     "665af973709071e982939f37ba39c79c6e41f7f18277d65670475ba9d8315f94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97b11f40a695dccaf6033a9911a9377984ffa7d3ed59bc1272fce7b3a0958edf"
  end

  def install
    system "make"
    bin.install "bchunk"
    man1.install "bchunk.1"
  end

  test do
    (testpath/"foo.cue").write <<~EOS
      foo.bin BINARY
      TRACK 01 MODE1/2352
      INDEX 01 00:00:00
    EOS

    touch testpath/"foo.bin"

    system "#{bin}/bchunk", "foo.bin", "foo.cue", "foo"
    assert_predicate testpath/"foo01.iso", :exist?
  end
end
