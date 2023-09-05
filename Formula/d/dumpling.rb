class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://github.com/pingcap/tidb/archive/refs/tags/v7.3.0.tar.gz"
  sha256 "3eb94ea19c25b88e325e83e8b57b02a0a7dce8438321e70f1429100f824c5bef"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4bc9a50c4dc1a46083c5d7172cc6c55374e4625dc2a8e47ac62cbb2535944401"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0c89e3a683e2836dd8046ac5074b4c55e67f1cdca1c818ccb8f22310909daef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "733bf39ee67f6557d9a028035b6ea029a2346757227942801986670421274b72"
    sha256 cellar: :any_skip_relocation, ventura:        "acb52fb20bc307af7b2d7a187c7c6374a3782e3e0a0193319de8810e7ff929fd"
    sha256 cellar: :any_skip_relocation, monterey:       "243e04e0af11865cba15265f7144bf9548c16eceeab5f6cf211b762413493ac7"
    sha256 cellar: :any_skip_relocation, big_sur:        "b797d21529bec159088f5cf4fd5973ac0bd3158e53d2bd2773b163d2bfd69c6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "678cf09ea48f91ea22fc582c49c0077b2a9a10fd964a29a5652f17f7c9dbbbaa"
  end

  depends_on "go" => :build

  def install
    project = "github.com/pingcap/tidb/dumpling"
    ldflags = %W[
      -s -w
      -X #{project}/cli.ReleaseVersion=#{version}
      -X #{project}/cli.BuildTimestamp=#{time.iso8601}
      -X #{project}/cli.GitHash=brew
      -X #{project}/cli.GitBranch=#{version}
      -X #{project}/cli.GoVersion=go#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./dumpling/cmd/dumpling"
  end

  test do
    output = shell_output("#{bin}/dumpling --database db 2>&1", 1)
    assert_match "create dumper failed", output

    assert_match "Release version: #{version}", shell_output("#{bin}/dumpling --version 2>&1")
  end
end
