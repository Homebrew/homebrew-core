class Abpoa < Formula
  desc "SIMD-based C library for fast partial order alignment using adaptive band"
  homepage "https://github.com/yangao07/abPOA"
  url "https://github.com/yangao07/abPOA/releases/download/v1.5.4/abPOA-v1.5.4.tar.gz"
  sha256 "15fc8c1ae07891d276009cf86d948105c2ba8a4a94823581f93744351c2fcf4a"
  license "MIT"
  head "https://github.com/yangao07/abPOA.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d23123224da086f407a2026aed50483642b6cb1cd773a95677e8823a7d203f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c32ab54105465ce6413049fa3e0b61751b4380ecd7f9cb8e871d7aaa4fd0fefa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be037ac65bb330b3c0346a0a73b9a52cd409c5d445bf5ea3b342c75937b6ff70"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6a18508fc01c5180ba29e543e889bf14572e4c37dee0e3de40936881d6a92d7"
    sha256 cellar: :any_skip_relocation, ventura:       "7b66dba3e1c7543bd65a85f1190be008acd8dc5246676df09674f3e30a9f890b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e22b15a4710bd352700931ef827c12fdcf6ba62177f120601dde18e2a6e6ace"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea53d24bfe80ecb229b8908a7e4cabbf5724b46e134272b00d776f261080c825"
  end

  uses_from_macos "zlib"

  def install
    system "make"
    bin.install "bin/abpoa"
    pkgshare.install "test_data"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/abpoa --version")
    cp_r pkgshare/"test_data/.", testpath
    assert_match ">Consensus_sequence", shell_output("#{bin}/abpoa seq.fa")
  end
end
