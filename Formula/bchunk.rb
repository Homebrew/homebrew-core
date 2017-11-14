class Bchunk < Formula
  desc "Convert CD images from .bin/.cue to .iso/.cdr"
  homepage "http://he.fi/bchunk/"
  url "http://he.fi/bchunk/bchunk-1.2.2.tar.gz"
  sha256 "e7d99b5b60ff0b94c540379f6396a670210400124544fb1af985dd3551eabd89"
  head "https://github.com/hessu/bchunk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0c9b730ab1db0beafaf377a84a5a8022a1578afa3900365774fefc6feb5fdcca" => :high_sierra
    sha256 "44166914413d7da28d342557b6a839f3aa181741fd99095ee5a671a3223cc427" => :sierra
    sha256 "5154795c1d3087e8c15791b3530a3b098859324cac18a4eabb7ba9e03b5dbb1f" => :el_capitan
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
