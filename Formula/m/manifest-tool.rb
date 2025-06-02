class ManifestTool < Formula
  desc "Command-line tool to create and query container image manifest list/indexes"
  homepage "https://github.com/estesp/manifest-tool/"
  url "https://github.com/estesp/manifest-tool/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "a3d770b7fde65d3146c0987e7e7b7be796a2a7a0556476c48b24bd237890cb06"
  license "Apache-2.0"
  head "https://github.com/estesp/manifest-tool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a037dc929dd0dfb5cad51397794e1a946d788a81bb54225498ecdb903271adb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52f7836f4546243d9036b58302d182eae370e2050586e83383bd863e94c4e84a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "04bea67d020b0f2db42ef098245253cda322f46bae79e4b4c235089821cf8a5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc3743f5f152b83dafc3081ef83286b8352280b7f4cda6fd1d04c0b3e0ab48f8"
    sha256 cellar: :any_skip_relocation, ventura:       "de24ccb775d338266c850e3a72fb5cac0b872f6040a4dde6b6003f9a36286f42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "784d810a6b808231da1660a46363ef9d55991f12b8edb69e5d5b38eaa2440227"
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
