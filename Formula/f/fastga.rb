class Fastga < Formula
  desc "Pairwise whole genome aligner"
  homepage "https://github.com/thegenemyers/FASTGA"
  url "https://github.com/thegenemyers/FASTGA/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "391a86ff3b9355f677e891fed23f3b9524b82f88b9905f1b482ce1144add1ab5"
  license all_of: ["BSD-3-Clause", "MIT"]
  head "https://github.com/thegenemyers/FASTGA.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00f9c966fef2b4cb9949449db2acdbfaec9dbf5b2b55f88ead27b7b3f34e77da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c156fa327ce7484a27c182fbcbba66d7f7c6f60fc0d4e74e73a3e6feb270f18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "669b1d360a91fe407f2e95540bd7451bb27147ddd6724f7d087f389140332bbc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "478e75f9a7f7f7cc9346e8341bf999cf7679360a915e39074ef0dfa6dc7b8e09"
    sha256 cellar: :any_skip_relocation, sonoma:        "368b40ce6c94389712eb97d65130b83c7b4344262d54d2a66f92bbad187836ea"
    sha256 cellar: :any_skip_relocation, ventura:       "bba546152682569103e1c26e42db0f25b19d165dde224131e2e38618c3a444ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e901783ee253ec3745826b76201220ba498acbbf0392548f005a395fae527b6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6701f46303473e85afc9f708275e54f18d15004aebbc73039355459caef41b9"
  end

  uses_from_macos "zlib"

  def install
    mkdir bin
    system "make"
    system "make", "install", "DEST_DIR=#{bin}"
    pkgshare.install "EXAMPLE"
  end

  test do
    cp Dir["#{pkgshare}/EXAMPLE/HAP*.fasta.gz"], testpath
    system bin/"FastGA", "-vk", "-1:H1vH2", "HAP1", "HAP2"
    assert_path_exists "H1vH2.1aln"
  end
end
