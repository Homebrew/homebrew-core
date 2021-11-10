class Mafft < Formula
  desc "Multiple alignments with fast Fourier transforms"
  homepage "https://mafft.cbrc.jp/alignment/software/"
  url "https://mafft.cbrc.jp/alignment/software/mafft-7.490-with-extensions-src.tgz"
  sha256 "d6eef33d8b9e282e20f9b25b6b6fb2757b9b6900e397ca621d56da86d9976541"

  # The regex below is intended to avoid releases with trailing "Experimental"
  # text after the link for the archive.
  livecheck do
    url "https://mafft.cbrc.jp/alignment/software/source.html"
    regex(%r{href=.*?mafft[._-]v?(\d+(?:\.\d+)+)-with-extensions-src\.t.+?</a>\s*?<(?:br[^>]*?|/li|/ul)>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07f59deffaa3c3ed1bf65a3d97ddb6a49e821b83756900a7f891f862652304fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f2d130b42194e1fc0fc8e04fc09b50ea8a2e0b4221b6247471036ff09f1ba47"
    sha256 cellar: :any_skip_relocation, monterey:       "dff65b18608995813d8fed1abaa0414678c101c8b799728770293227e87c8af9"
    sha256 cellar: :any_skip_relocation, big_sur:        "2128b37a707fdef7a6c45f19b8abcfefca4ebe37077d2a783711a568b5a4b7eb"
    sha256 cellar: :any_skip_relocation, catalina:       "3dc223c186c006a5646bb6de73badbbd2b327c8bca7e2d2a342ff28dd1f4f92b"
    sha256 cellar: :any_skip_relocation, mojave:         "0b6a7c8d20f75c44fc690974ebeee2d7ee7ddcb8f1f5e0b56da5c35b42aaaa53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8fa1cf45a410954e6b3697f2003580d62f3f1885cafbd28d2f80a7cc66fb293"
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
