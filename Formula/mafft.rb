class Mafft < Formula
  desc "Multiple alignments with fast Fourier transforms"
  homepage "https://mafft.cbrc.jp/alignment/software/"
  url "https://mafft.cbrc.jp/alignment/software/mafft-7.481-with-extensions-src.tgz"
  sha256 "7397f1193048587a3d887e46a353418e67849f71729764e8195b218e3453dfa2"

  # The regex below is intended to avoid releases with trailing "Experimental"
  # text after the link for the archive.
  livecheck do
    url "https://mafft.cbrc.jp/alignment/software/source.html"
    regex(%r{href=.*?mafft[._-]v?(\d+(?:\.\d+)+)-with-extensions-src\.t.+?</a>\s*?<(?:br[^>]*?|/li|/ul)>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "91b03104ff5f30757dbedd718a78cd645ad16a1a6688abf325a7b8fc348a8b33"
    sha256 cellar: :any_skip_relocation, big_sur:       "9dc1f412ecf13f900a82a0599c89b59770135d67f60ab4f1341c2c614fdbdb03"
    sha256 cellar: :any_skip_relocation, catalina:      "713146b4b684418a6aefe6001f828cf601b5250068e8f26b036a68ea915585bc"
    sha256 cellar: :any_skip_relocation, mojave:        "bb7e9f17d362f385847dc71fac8d184f8e2f2b46683fcbe41bfb77bfe7cb3a91"
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
