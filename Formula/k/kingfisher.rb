class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v1.90.0.tar.gz"
  sha256 "b230d0000e49526178e2972d57874e09da17efd586632f86a20f7804332a9627"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5ae41645f476f173cc836dc03f59b3ee183b2834249ddb29e165043f0759e65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b05e4d1153ae3612d6ab8c0c9fdb3a5f504e490561d17b50dc2c699658a4da50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "264892ff27fcc12969a8404c1636d75dfd952828a06c4ef61a586c7829dcdf8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9c9a9d033677979d3a8f4c0dda62ffb76788c48733624b4348501f2a91a2c58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9e470435b4437970ced3774e70fc430327d9eff6304546c87633184e9ce2abb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f8f4e99ee0a8167ef843ae6c49627765a9974f1f5150d7d620101d9e6920913"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", *std_cargo_args(features: "system-alloc")
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end
