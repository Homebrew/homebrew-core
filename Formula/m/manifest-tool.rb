class ManifestTool < Formula
  desc "Command-line tool to create and query container image manifest list/indexes"
  homepage "https://github.com/estesp/manifest-tool/"
  url "https://github.com/estesp/manifest-tool/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "99b47f6da69a82a75f9be7d0bc47e6b4a0e622628f2c208d58e817c834bb4492"
  license "Apache-2.0"
  head "https://github.com/estesp/manifest-tool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d86a129900236772b789cc46793fd5ac69076c8c26d6705eb9487d406df73ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbf3bfa0de08498c8103ee559d7010ecdeb1f45c711b45da4f251c3ba87bf1d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35fa8b8f4a1d8913864070048735074e585d7d7241f1a7fdf1aa8ffa77d8e1b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "96cfe0869400dc028832b0d3e8b9cc90b8061ae4a852614dbd43f3d9a4ee354e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d836460da1d037f59c0853b1e2689c693ea159427ba29ee099b5738e23c7c0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac682859f43c8871a1a178907a2c969dec9d7270add5bbed005fc46754c26b96"
  end

  depends_on "go" => :build

  def install
    system "make", "all"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    package = "busybox:latest"
    stdout, stderr, = Open3.capture3(
      bin/"manifest-tool", "inspect",
      package
    )

    if stderr.lines.grep(/429 Too Many Requests/).first
      print "Can't test against docker hub\n"
      print stderr.lines.join("\n")
    else
      assert_match package, stdout.lines.grep(/^Name:/).first
      assert_match "sha", stdout.lines.grep(/Digest:/).first
      assert_match "Platform:", stdout.lines.grep(/Platform:/).first
      assert_match "OS:", stdout.lines.grep(/OS:\s*linux/).first
      assert_match "Arch:", stdout.lines.grep(/Arch:\s*amd64/).first
    end

    assert_match version.to_s, shell_output("#{bin}/manifest-tool --version")
  end
end
