class Bchunk < Formula
  desc "Convert CD images from .bin/.cue to .iso/.cdr"
  homepage "http://he.fi/bchunk/"
  url "http://he.fi/bchunk/bchunk-1.2.0.tar.gz"
  sha256 "afdc9d5e38bdd16f0b8b9d9d382b0faee0b1e0494446d686a08b256446f78b5d"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe99f8ae0d17d4e2c1aaea4379d074d9d7299d911b66ebf3f061405471ace147" => :sierra
    sha256 "150759123521a6c5aa18471a6474d248cc69b5f5b4c6284f8081988c95e26353" => :el_capitan
    sha256 "196d12168c9e570676e5ae905e7a85226b7b37d867b5f850d3d82e6157627750" => :yosemite
    sha256 "d823c661e0786dbde185a8f7de5f70c2ba2304ece128d4abfa35c0eb2c471477" => :mavericks
  end

  def install
    system "make"
    bin.install "bchunk"
    man1.install "bchunk.1"
  end

  test do
    (testpath/"foo.cue").write <<-EOS.undent
    foo.bin BINARY
    TRACK 01 MODE1/2352
    INDEX 01 00:00:00
    EOS

    touch testpath/"foo.bin"

    system "#{bin}/bchunk", "foo.bin", "foo.cue", "foo"
    assert File.exist? testpath/"foo01.iso"
  end
end
