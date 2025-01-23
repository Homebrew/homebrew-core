class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://github.com/pingcap/tidb/archive/refs/tags/v8.5.1.tar.gz"
  sha256 "5266d6d4657c4b8fe805e63f885afd2ed189c34ed25174f9ff17b8a3392208f0"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6715a2eff19789a8226fd793c666467fb293a850eb7ce16bfa521d3d5e71ad84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8801737a27e7d2ac8480b200e3cd93c93c85890e6c9262ed2da27feab78991d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1dc9cb3092baa6e4724deddc2ca90a367d568733fc9bbec3551380f891c2334"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b81af5b162a3d46429358564ff50cc35d9b4764d699c475dba3554059923c38"
    sha256 cellar: :any_skip_relocation, ventura:       "245acffe14d7a85d822ccd801c1da66d2dcfddf2f9bf28353d0ee5b8423816cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c49cf78d2f80ea4fae79fc6f4478feb9ba9957c818dbd92455f95ee7aee39db7"
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
