class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://github.com/pingcap/tidb.git",
      tag:      "v6.3.0",
      revision: "ecd67531f1721d3e49eb15a202ac7c0ae02291ec"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b956323ee5b58d8af6cf27a72c0acb8270fb486ea68bbd0a621971f248563434"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c343ce9c544e7fb4af81f0e13c8712316e8c9ac5a10bc005e12a356bb7539c8a"
    sha256 cellar: :any_skip_relocation, monterey:       "e5802a5277e82869c3e3f6b09a0e13de9cd90a68cecd6e656b99dc82a32d5483"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2632c91d969b5132ddb79b0a66cc43b2dbb038a01cad1f17ff0f8233cc69461"
    sha256 cellar: :any_skip_relocation, catalina:       "9016ea1942296b339f005369375d3b6c303e5da2b55a89e1d1528c76b6f4dacb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1308acb683ef8365cdef4ed3118d7b66846bf4bfe52c851a50a37ec748b6cec7"
  end

  depends_on "go" => :build

  def install
    project = "github.com/pingcap/tidb/dumpling"
    ldflags = %W[
      -s -w
      -X #{project}/cli.ReleaseVersion=#{version}
      -X #{project}/cli.BuildTimestamp=#{time.iso8601}
      -X #{project}/cli.GitHash=#{Utils.git_head}
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
