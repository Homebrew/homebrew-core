class ManifestTool < Formula
  desc "Command-line tool to create and query container image manifest list/indexes"
  homepage "https://github.com/estesp/manifest-tool/"
  url "https://github.com/estesp/manifest-tool/archive/refs/tags/v2.1.6.tar.gz"
  sha256 "b92801e032d0c0ce5714dfd120551939a4e0db16be3d3315d3e1d6dd03bb9be6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "972c6533ac4e024b66809212bcb7744d4aa16de7fbc45f0787eeb926b118dd89"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96ed3800f775332ea1c655d832de37d88eb715b2d5c10cce0c9e6fc6758a5555"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e46c37a2e774c5fd61c37525ec2462871a94a2a87f59921d18938278a4122c4d"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf46e7aeeda1e772dd3d8229c78ed8c0fc28a99c070799a8c0b39c022ce423b7"
    sha256 cellar: :any_skip_relocation, ventura:        "b902934a3dce529d0a91927e9d55a92ce16717b68b1b7bb32236d818d3003f99"
    sha256 cellar: :any_skip_relocation, monterey:       "8a66126c030352fdc96c5fdf1d6882386271b74b908b9dc0139671d97821614d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30afd13173de3932bfede02d0166fa0d1345cb506eef16eb2c1d4c0df8a98900"
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
