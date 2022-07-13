class ManifestTool < Formula
  desc "Command-line tool to create and query container image manifest list/indexes"
  homepage "https://github.com/estesp/manifest-tool/"
  url "https://github.com/estesp/manifest-tool/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "3adff8238c21a81ac51dda1f5d83ce8ed6da0d151bf4f3371a1d0e8833e351f3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "086807fbc9f62582bbc2a176b2e93fd00aee8afda6388104388ce18a15398b37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de7390c1fce5430431bfa74dd1a9f258ab825a41d3ded6b00ea502f5fd5b563a"
    sha256 cellar: :any_skip_relocation, monterey:       "62678dc2db8cd0d117f139d69235df7667d5b018498f0c871d6dfd170d62430b"
    sha256 cellar: :any_skip_relocation, big_sur:        "603dbc2e0957c169ecc8362ffdfb4de9fad87b95adc787f095d06d736b10182f"
    sha256 cellar: :any_skip_relocation, catalina:       "4f1bf326c4627260fc1e3096ac41987ef7c4367a09da40b053b1809ba4e1a53f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a13299381c3ecc2375fa19a318ac019039f72acf016be5b9c2aae33d9220534c"
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
