class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://github.com/pingcap/tidb/archive/refs/tags/v8.3.0.tar.gz"
  sha256 "3380265ac8d9ccc41b88315c07e05ba28ec78871296300be9a6e64281facec54"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c71ccf926900b779b3e1e0871a2a2de66ff866d73a1522a74e1df0eeb486c67f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "190389975f1d3e786b865856044a9c2e32dbe111e8f0b72bb530670c05590b46"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "610833b93188649c92c779c4e1005353293e362b08b776101df4c1b89f626fd9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a342d6eedb98eab02b5070d951e80af36dd0684eec8a2c586ae5100be1b5dbe"
    sha256 cellar: :any_skip_relocation, sonoma:         "b17e5de9f59422168ca05d0071e13e359c67664d499c9e5884d87c7042c45781"
    sha256 cellar: :any_skip_relocation, ventura:        "1d72a292853127c68109cd6714e592a6146f1fa5c731f0b2fca7925cf66f6a0f"
    sha256 cellar: :any_skip_relocation, monterey:       "bb0129ba6dceac05138b9ced19e19f4105bf6410af6582ad506c9153a46e84cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a10557ac5fdff15ea0d8127faaf6f503f0424099038a04a39d2efd902c6b9d0a"
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

    system "go", "build", *std_go_args(ldflags:), "./dumpling/cmd/dumpling"
  end

  test do
    output = shell_output("#{bin}/dumpling --database db 2>&1", 1)
    assert_match "create dumper failed", output

    assert_match "Release version: #{version}", shell_output("#{bin}/dumpling --version 2>&1")
  end
end
