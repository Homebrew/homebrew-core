class Mage < Formula
  desc "Make/rake-like build tool using Go"
  homepage "https://magefile.org"
  url "https://github.com/magefile/mage.git",
      tag:      "v1.13.0",
      revision: "3504e09d7fcfdeab6e70281edce5d5dfb205f31a"
  license "Apache-2.0"
  head "https://github.com/magefile/mage.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1d1b6476ecda13b01bcadb780b6e2788aaa824a65ef14c41cfb0bb5ed6c93bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c1d1b6476ecda13b01bcadb780b6e2788aaa824a65ef14c41cfb0bb5ed6c93bc"
    sha256 cellar: :any_skip_relocation, monterey:       "cdce99922ea340bb7fb022bba39b6524ebce3da456f26334ab68bd77d8d10277"
    sha256 cellar: :any_skip_relocation, big_sur:        "cdce99922ea340bb7fb022bba39b6524ebce3da456f26334ab68bd77d8d10277"
    sha256 cellar: :any_skip_relocation, catalina:       "cdce99922ea340bb7fb022bba39b6524ebce3da456f26334ab68bd77d8d10277"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9045efef23a031c07ab4fd7efe5b6b5b6d67002156b6fdd5b9f8e1a0ae80bca5"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X github.com/magefile/mage/mage.timestamp=#{time.rfc3339}
      -X github.com/magefile/mage/mage.commitHash=#{Utils.git_short_head}
      -X github.com/magefile/mage/mage.gitTag=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match "magefile.go created", shell_output("#{bin}/mage -init 2>&1")
    assert_predicate testpath/"magefile.go", :exist?
  end
end
