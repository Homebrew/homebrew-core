class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://github.com/pingcap/tidb/archive/refs/tags/v8.5.5.tar.gz"
  sha256 "2dee41c6e6f1251ef5aa820cbb8c47950069e3e2baeb26072604d6be25498ecd"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5844a11f18582d626238f91d0a2aa0e5df9067b14b4ff6481d76751c49ca6bae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e61551c2cc9561b920bfb1fae76a34453fd9e4b2342111b2cf38b8552a595119"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89b16c443161aa8af29d9d67c2bfba4a2c3c1bd83934deae7db40f660a7834ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e379fc76aad5816a8b9bf3711a12c47c0b64e67de8271670b1467f9ba6ff623"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be17bd146f8d0e5214ad39a850dc55d2f741bbcf495a968e3857024df44fd664"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfc64eb60af9ecd9ba221226e92abf183890db5e55ebfca027681ec52c0a2700"
  end

  depends_on "go" => :build

  def install
    project = "github.com/pingcap/tidb/dumpling"
    ldflags = %W[
      -s -w
      -X #{project}/cli.ReleaseVersion=#{version}
      -X #{project}/cli.BuildTimestamp=#{time.iso8601}
      -X #{project}/cli.GitHash=#{tap.user}
      -X #{project}/cli.GitBranch=#{version}
      -X #{project}/cli.GoVersion=go#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./dumpling/cmd/dumpling"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dumpling --version 2>&1")

    output = shell_output("#{bin}/dumpling --host does-not-exist.invalid --port 1 --database db 2>&1", 1)
    assert_match "create dumper failed", output
  end
end
