class ManifestTool < Formula
  desc "Command-line tool to create and query container image manifest list/indexes"
  homepage "https://github.com/estesp/manifest-tool/"
  url "https://github.com/estesp/manifest-tool/archive/refs/tags/v2.0.6.tar.gz"
  sha256 "dd461878794c760ff81fdcb93bf95cadfad4d53ef5044d207a06e15442ddd3f8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42b358798b4ec2c454b00f750147bf47d7e801708f8ba84308d302041cfe47ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8b682e89f12fa2f61e70bcb71636d5a945439411c7e58a332540e8e83589ad8"
    sha256 cellar: :any_skip_relocation, monterey:       "f9dc01750d364f7124e2ffc0c64a0c9ee065256e5eaf997af5daf70c8568448e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3c0e5b02efc40a188b6d6e7c288ee91c74bbb18697688ca6152d0f758b65fe3"
    sha256 cellar: :any_skip_relocation, catalina:       "30e368dfaf1a9363506c56dba4e2e3f90fd8807b7389be70a75270fb2f97b67f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e9c2f5be3048a680e40e5abc459d8d06769afdcaa6ba9d9d93c3c8c2403a107"
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
