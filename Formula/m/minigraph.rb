class Minigraph < Formula
  desc "Proof-of-concept seq-to-graph mapper and graph generator"
  homepage "https://lh3.github.io/minigraph"
  url "https://github.com/lh3/minigraph/archive/refs/tags/v0.21.tar.gz"
  sha256 "4272447393f0ae1e656376abe144de96cbafc777414d4c496f735dd4a6d3c06a"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "e1f725e6105e8492fb5d6fc2e7a1d34908dc1a48f649cfdaee1b35d33c1cde6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "74910ce15f23503fe34b6b8a2fcd5e42fc77c5d9731af7901d4f37abb8b2291d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c97ede2ba9819f38713bba63399fa4386a5f9ad7b1d69da1ec59c93e041b676"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c732ab52d288ebc25d387a00ec4df300a29c3e0d47215a39e8f08a2aba06ff99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "671d905a9d3bc672efedf7169d79a577c0df8bb0fc1fd8d6ff0f71b8014ba1de"
    sha256 cellar: :any_skip_relocation, sonoma:         "41b0c146e36c565da5aa7b60f21b4ddd2ff463b20ad1f14b155b3f6b66b980ff"
    sha256 cellar: :any_skip_relocation, ventura:        "5bb664d3a2608ad6213e5d60cec28a144f9ce230991ba8c4d9ccb50c57503d84"
    sha256 cellar: :any_skip_relocation, monterey:       "ec305e269ea8fc05307c59757a55b73f8afd8c4b91ff878b91015fe432863c96"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f8bb2dee04f9410b06916cdcbd208e353e319fd5a928b067af88715d676cb046"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66fe3ea02850e9c7c043cf189d474d2e866b8c2f3540bf4338864c070a6be913"
  end

  uses_from_macos "zlib"

  def install
    sse4 = Hardware::CPU.intel? && ((OS.mac? && MacOS.version.requires_sse4?) ||
                                    (!build.bottle? && Hardware::CPU.sse4?))
    unless sse4
      inreplace "Makefile" do |s|
        cflags = s.get_make_var("CFLAGS").split
        cflags.delete("-msse4") { |flag| "Remove inreplace for #{flag}!" }
        s.change_make_var! "CFLAGS", cflags.join(" ")
      end
    end

    system "make"
    bin.install "minigraph"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test/.", testpath
    output = shell_output("#{bin}/minigraph MT-human.fa MT-orangA.fa 2>&1")
    assert_match "mapped 1 sequences", output
  end
end
