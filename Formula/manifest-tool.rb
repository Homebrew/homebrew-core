class ManifestTool < Formula
  desc "Command-line tool to create and query container image manifest list/indexes"
  homepage "https://github.com/estesp/manifest-tool/"
  url "https://github.com/estesp/manifest-tool/archive/refs/tags/v2.0.6.tar.gz"
  sha256 "dd461878794c760ff81fdcb93bf95cadfad4d53ef5044d207a06e15442ddd3f8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6a12ae584f23e1940f972f4a672e1cb48c69dd8184b1eb801fe10a1ddaf52fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5dca5344a17ae9648e59674d1030ca0c82c43f205fb7ad53a9cbd1489ee6343b"
    sha256 cellar: :any_skip_relocation, monterey:       "9a96c9beb33f49a728814fff6ecb912400d30742e2cca52ff690318b49d4ac95"
    sha256 cellar: :any_skip_relocation, big_sur:        "bcf583dede09cb63b100109857e5cace05161ac0cf1cf95bf94e2194e257ad1b"
    sha256 cellar: :any_skip_relocation, catalina:       "16fb73f39fc8fe038d345a921951e2c2a6c4438d29959680f6fc587388bb43d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcca7bd37323cd666b96ff851b390e786c04ec1639fdb9c161e50515adaae153"
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
