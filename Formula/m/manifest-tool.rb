class ManifestTool < Formula
  desc "Command-line tool to create and query container image manifest list/indexes"
  homepage "https://github.com/estesp/manifest-tool/"
  url "https://github.com/estesp/manifest-tool/archive/refs/tags/v2.1.7.tar.gz"
  sha256 "fcf163faad3aff112593f1e648a750e08014ba83d43739e9a5bb0f0e9f0927ca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00c822837fcebc8ba92cb2440c5339b1875f267586a612d1407ec666d81494c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "472cb9d36b0f005282b790b4f134fe3e436d9b578a74d7b693285fa16c0e984f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5ac24ba9596cac9e41a715f4de5ef50dc8abd3dc4da6209375fed924105b791"
    sha256 cellar: :any_skip_relocation, sonoma:         "1709b2ce3705956f3c0889e915c9fc51f5668d6ab78ecba89a10e5053807efb8"
    sha256 cellar: :any_skip_relocation, ventura:        "ef30dbeace12c20e3aa7324c1384280dcc147679ed564ba50f1c79a0618661f4"
    sha256 cellar: :any_skip_relocation, monterey:       "399bfcb8761a795af3afdefdd093d2bc71723ebd1be93b709f4da4fa4b1592fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "523d53eb4737435418928e59af054f978d9f382fdd203c32ea125c0e106d7462"
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
