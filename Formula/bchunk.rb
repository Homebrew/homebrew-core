class Bchunk < Formula
  desc "Convert CD images from .bin/.cue to .iso/.cdr"
  homepage "http://he.fi/bchunk/"
  url "http://he.fi/bchunk/bchunk-1.2.0.tar.gz"
  sha256 "afdc9d5e38bdd16f0b8b9d9d382b0faee0b1e0494446d686a08b256446f78b5d"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "db47b08d8b2a9c0a609c04871650a539e032015058cd45f90ebb802575674259" => :high_sierra
    sha256 "fe99f8ae0d17d4e2c1aaea4379d074d9d7299d911b66ebf3f061405471ace147" => :sierra
    sha256 "150759123521a6c5aa18471a6474d248cc69b5f5b4c6284f8081988c95e26353" => :el_capitan
    sha256 "196d12168c9e570676e5ae905e7a85226b7b37d867b5f850d3d82e6157627750" => :yosemite
    sha256 "d823c661e0786dbde185a8f7de5f70c2ba2304ece128d4abfa35c0eb2c471477" => :mavericks
  end

  # Last upstream release was in 2004, so probably safe to assume this isn't
  # going away any time soon.
  patch do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/b/bchunk/bchunk_1.2.0-12.1.debian.tar.xz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/b/bchunk/bchunk_1.2.0-12.1.debian.tar.xz"
    sha256 "8c7b530e37f0ebcce673c74962214da02aff7bb1ecc96a4dd359e6115f5c0f57"
    apply "patches/01-track-size.patch",
          "patches/CVE-2017-15953.patch",
          "patches/CVE-2017-15955.patch"
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
