class Mafft < Formula
  desc "Multiple alignments with fast Fourier transforms"
  homepage "https://mafft.cbrc.jp/alignment/software/"
  url "https://mafft.cbrc.jp/alignment/software/mafft-7.475-with-extensions-src.tgz"
  sha256 "bb6973ae089ea18cfbd3861a5b9d2c8b7e1543a1fdc78ac2d7cd8dbe3443f319"

  # The regex below is intended to avoid releases with trailing "Experimental"
  # text after the link for the archive.
  livecheck do
    url "https://mafft.cbrc.jp/alignment/software/source.html"
    regex(%r{href=.*?mafft[._-]v?(\d+(?:\.\d+)+)-with-extensions-src\.t.+?</a>\s*?<(?:br[^>]*?|/li|/ul)>}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c77a7f7d15ad593abfb323f568cd2a940b16e6e5c8fb4d9fd63a824967117505" => :big_sur
    sha256 "47030809ef8372782fbf5770b2b95057f31bcbf81ead53cb06cb09e2ecbd2f87" => :catalina
    sha256 "f7820f8386beaa0b0bfcfccc75bea1563d3b5947e32a0aba5051edb621491026" => :mojave
    sha256 "a194f9f065024b846417688c2da31c22c058598880c4fb8ef5369e10299ecf2f" => :high_sierra
  end

  def install
    make_args = %W[CC=#{ENV.cc} CXX=#{ENV.cxx} PREFIX=#{prefix} install]
    system "make", "-C", "core", *make_args
    system "make", "-C", "extensions", *make_args
  end

  test do
    (testpath/"test.fa").write ">1\nA\n>2\nA"
    output = shell_output("#{bin}/mafft test.fa")
    assert_match ">1\na\n>2\na", output
  end
end
