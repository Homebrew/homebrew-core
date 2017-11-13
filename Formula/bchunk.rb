class Bchunk < Formula
  desc "Convert CD images from .bin/.cue to .iso/.cdr"
  homepage "http://he.fi/bchunk/"
  url "http://he.fi/bchunk/bchunk-1.2.0.tar.gz"
  sha256 "afdc9d5e38bdd16f0b8b9d9d382b0faee0b1e0494446d686a08b256446f78b5d"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "0c9b730ab1db0beafaf377a84a5a8022a1578afa3900365774fefc6feb5fdcca" => :high_sierra
    sha256 "44166914413d7da28d342557b6a839f3aa181741fd99095ee5a671a3223cc427" => :sierra
    sha256 "5154795c1d3087e8c15791b3530a3b098859324cac18a4eabb7ba9e03b5dbb1f" => :el_capitan
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
