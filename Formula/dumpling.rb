class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://github.com/pingcap/tidb.git",
      tag:      "v6.6.0",
      revision: "f4ca0821fb96a2bdd37d2fb97eb26c07fc58d4e4"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c168394774259627b11b09f66e7a2be6f21b648c3326e977341f411f45127a3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "077e761679c1d7b3301976a983637fb235043d31fdcef47669d447c90c03ca71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b38a71890d7814187dd891dd51e99755fc40de054f9930f13835588bbb3caf7"
    sha256 cellar: :any_skip_relocation, ventura:        "fca3705bdd2355d12623351b6867c4537d8977b824826eea9f29fec6fba21b16"
    sha256 cellar: :any_skip_relocation, monterey:       "cc3224da5fed206aa7625bcde656d9f4a9c272cb7ecd40a546d5d48aa7d323d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "391b960893f9c89d73f68201576fbd47356fafd850bed23a57dcc6982fb00b30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b03b5cc3aee82f00d634bf9e18d4b00170681cee8462e271b014c7ee6b7dd2fb"
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
