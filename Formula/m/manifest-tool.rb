class ManifestTool < Formula
  desc "Command-line tool to create and query container image manifest list/indexes"
  homepage "https://github.com/estesp/manifest-tool/"
  url "https://github.com/estesp/manifest-tool/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "20f3136b61614bb72b4b95342644e78345a544091dc5ae660d0237ecebc102ff"
  license "Apache-2.0"
  head "https://github.com/estesp/manifest-tool.git", branch: "main"

  bottle do
    manifest_sha256 "4190f481fd52a6bdea981389d2e35eb508e098eed1fae98877383457da035da4"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "660e4bf09f645873e17d5374706ea9e08117bf15fa39f670279aa65809d9f0a1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "56193e4529f14a40d3806db63dcb92097f8bdd24407040f791262af93067561a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4e3bf78982962094d2bb1bbb36c462a633c2fe9c8337978b75ded3794107f865"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "faf3643b9708f26c6ebd8b934a4becd51ee7d7e33995aa6d3f54ef74ab02b20c"
    sha256 cellar: :any,                 x86_64_linux:      "0eebdc764623f496e874d5debe9d70b139af37999ee91fe908ad46be16ee0e5b"
  end

  depends_on "go" => :build

  allow_network_access! :test

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
