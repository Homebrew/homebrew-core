class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://github.com/pingcap/tidb/archive/refs/tags/v7.6.0.tar.gz"
  sha256 "f7c9c022b8fc5c038693bfde67d1f360f3295161789abae5768534aea1fa42a5"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8bfb4d85f7e136f387f96e33019ffaeea150b55470a38db0262d381ce91de2e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae439fc2af01686915634f06d6731cdbb0a9bafe77c7de6d1f9e4d96a42c1571"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5e274dc6a8f34a2f38c56d95fe846f612bbc61d4bb2bb2f5858bf13cb4f7038"
    sha256 cellar: :any_skip_relocation, sonoma:         "821bf1771930f9d8852f9a497396433f0f2117c729e20dec5e0dd57313524f3a"
    sha256 cellar: :any_skip_relocation, ventura:        "9df42e1b4f1ca409e6562c7e027c2de3aed43a4458a5de4f27e261a4a7be2010"
    sha256 cellar: :any_skip_relocation, monterey:       "79a2c4498bc243533ae5e77f94936e05ae554e2a0ca3f67b69f9011a43682ee4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e3edbeae8560b058672dbdb042d6708183af3c5e0084cff28bb31781a225bb1"
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
