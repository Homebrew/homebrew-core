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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ce2343170fba164088b8d138cb9043b5e3cd4674327243d3e6530aabb63082a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a28296f4008623699ca60650cb7bbc4bfafa85aecb9a4b7b446db67b26b3edbd"
    sha256 cellar: :any_skip_relocation, monterey:       "75f785fd4c67164de44a419b3eb75cb51ffce3c346d6c87958706267bcf36b3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4e4474c70b87a31a5b439013f9a1d747bb61f2ce9dd578950675a995cc7fb0f"
    sha256 cellar: :any_skip_relocation, catalina:       "40c08564f300305c9e279255cceca05e89c85362d3dcf23dd474c86a4074c3f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a496b783ed050a16748f638289c61b17cc54729ae17d61df879909adcfcb5e64"
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
