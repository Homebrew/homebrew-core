class Minimap2 < Formula
  desc "Versatile pairwise aligner for genomic and spliced nucleotide sequences"
  homepage "https://lh3.github.io/minimap2"
  url "https://github.com/lh3/minimap2/archive/refs/tags/v2.28.tar.gz"
  sha256 "5ea6683b4184b5c49f6dbaef2bc5b66155e405888a0790d1b21fd3c93e474278"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7892d7b6dadbe330c7b9f089ffbc8d1ce7b7090785cedcfb668e470c306a0bfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91f0f660030b496f34f119694e94a9e5f21e192ae9a242772800d2347134b200"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8393b64e8433871aa7f0f69ba4774bab7504f07833a436042872fcfc01a1f5f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "5502e3cf0b1ec825425b20fb1197f2507a08662f2c13151556eee608c4999609"
    sha256 cellar: :any_skip_relocation, ventura:       "9ae2dfa074f8f987c30d18a4e6634c5ba7eb2cb3634514bf15662b32f30b5b4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f50b9821c693522bf79fbf89df9253a519976ee26ce722ac3c83b3b5242ec65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fd42a0a8241e19a154f8caae8f18ab682edd88274a0e68df0d3a805cc825d3e"
  end

  uses_from_macos "zlib"

  def install
    if Hardware::CPU.arm?
      system "make", "arm_neon=1", "aarch64=1", "extra"
    else
      system "make", "extra"
    end
    bin.install "minimap2", "sdust"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test/.", testpath
    output = shell_output("#{bin}/minimap2 -a MT-human.fa MT-orang.fa 2>&1")
    assert_match "mapped 1 sequences", output
  end
end
