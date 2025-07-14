class Fastga < Formula
  desc "Pairwise whole genome aligner"
  homepage "https://github.com/thegenemyers/FASTGA"
  url "https://github.com/thegenemyers/FASTGA/archive/refs/tags/v1.2.tar.gz"
  sha256 "35a264fc1f6c7db35d99879bebca91a32173bf835393e7311c082efb633b87da"
  license all_of: ["BSD-3-Clause", "MIT"]
  head "https://github.com/thegenemyers/FASTGA.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cf6fbdcd9c0ddbfb7392104717c9d700919b919f96569839b69488b1c18771d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e41f37ccfc620233339a799213045969c5a6688eec7ed821d8a85e7b70c340a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc86a1bb437e55671025d7456ff8ed5628fa7bd0e8e2dd15b574d30a67e440ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "b687ad3af1c60cd453831a3a77facbd5ee53c86b13fa6ae875c9ff065ce0943f"
    sha256 cellar: :any_skip_relocation, ventura:       "2b09e2caed16aff625d29878bbd8ce07c8e3902e5d54bf6bb4a8a76cf53aaa37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "711a756168779b81e9024372ada2cda4bae5dc7b9c9b6a638a02e211b311bedc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c752402bb321d261b1e46d368eed6459a3d59ac3eb3000cc5dafbb6857e234c8"
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
