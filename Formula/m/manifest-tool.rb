class ManifestTool < Formula
  desc "Command-line tool to create and query container image manifest list/indexes"
  homepage "https://github.com/estesp/manifest-tool/"
  url "https://github.com/estesp/manifest-tool/archive/refs/tags/v2.1.8.tar.gz"
  sha256 "5e30dfc72c09e2d38544bda4caa40aa6cc9dcc9a5e7855e310ced3ba532095e5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "653a42187d4ae25891bb612098fc8384622de106cf638c048c19959daace98e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "327a6a948887469f2dcb89854f36c7a3c185ef1213dfd36f74bfd83a70a9ffae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "966c129e645ee6562182c2a2c548770da709655bc58d98d3c4dc669ab857bf1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "159897ecc78a88b02b652619a6bd807dd73114957358640c189dbd8dcf423fe0"
    sha256 cellar: :any_skip_relocation, ventura:       "9642beb655085b119b989fa71f353c7a6545229109a267051a900f55c16735f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddb94b3dbe3dc431c01e45d0830adae3c0c21fc378b15594b0f96683ffa74204"
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
