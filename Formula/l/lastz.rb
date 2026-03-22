class Lastz < Formula
  desc "Pairwise aligner for DNA sequences"
  homepage "https://lastz.github.io/lastz/"
  url "https://github.com/lastz/lastz/archive/refs/tags/1.04.52.tar.gz"
  sha256 "274bf0d774e3f4da87c23ca0b5cc4269f3dcaecf71a1c6289d426e24fbccf4c8"
  license "MIT"
  head "https://github.com/lastz/lastz.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80f6fff47c343b4c7ace97eaae35488f03769f97fd9133f886c7bb34d95352e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d663670926ee95d2ef1724b63284c96fb3f3a0a1c517f67a3066aaf9f2c03ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "591be15975aa9dd43fd51b15ed647d79dc22724fbf206af81baf67b3d8fe4877"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f64eee65d64b28cf1cdbaf97b1c1f59289aa1add290e394d778377245645f57"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbf9f6ac6360306a7d16069ba875c3b7bbc8bf519eeeae744d1e3fd2a9b67ed9"
    sha256 cellar: :any_skip_relocation, ventura:       "87ed31cf1d1be9434962ea5261dedf49c514a452fa6f98e4e0c59219cb41c34c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "def54adb8c80103f68796212aa25a879efef110fc751f811c821e1508793772a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b99c52372809d20f0228dc754d73c23fb5bf8bf0654025b472eba065b4341aec"
  end

  def install
    system "make", "install", "definedForAll=-Wall", "LASTZ_INSTALL=#{bin}"
    doc.install "README.lastz.html"
    pkgshare.install "test_data", "tools"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lastz --version", 1)
    assert_match "MAF", shell_output("#{bin}/lastz --help=formats", 1)
    dir = pkgshare/"test_data"
    assert_match "#:lav", shell_output("#{bin}/lastz #{dir}/pseudocat.fa #{dir}/pseudopig.fa")
  end
end
