class Bchunk < Formula
  desc "Convert CD images from .bin/.cue to .iso/.cdr"
  homepage "http://he.fi/bchunk/"
  url "http://he.fi/bchunk/bchunk-1.2.2.tar.gz"
  sha256 "e7d99b5b60ff0b94c540379f6396a670210400124544fb1af985dd3551eabd89"
  head "https://github.com/hessu/bchunk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b9f7bc758711585d7a016b7b3ddefe3256a368c00b21c51691481c7fbfc2823a" => :catalina
    sha256 "232935a7e7291016af594df742848d851ceca12ff9c06e183485c6a184c1df38" => :mojave
    sha256 "d6183607b5b987345ee3380263819f1d5e12f2f3cc9f6fd55accfbf92c26d5ef" => :high_sierra
    sha256 "95ef5fddc2234902187dde834690fb5957bd99ce11403e3d0f8881a705bb8f27" => :sierra
    sha256 "665af973709071e982939f37ba39c79c6e41f7f18277d65670475ba9d8315f94" => :el_capitan
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
