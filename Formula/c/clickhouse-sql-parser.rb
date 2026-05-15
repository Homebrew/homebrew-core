class ClickhouseSqlParser < Formula
  desc "Writing clickhouse sql parser in pure Go"
  homepage "https://github.com/AfterShip/clickhouse-sql-parser"
  url "https://github.com/AfterShip/clickhouse-sql-parser/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "dd07759984410a40cc7ad5b78a6d77af66f1792f417b053adf7c47346523ba21"
  license "MIT"
  head "https://github.com/AfterShip/clickhouse-sql-parser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91013f4dd4e2e4d3a0de3f2fe53bb60691fae3d7e76a9d35e9f5a8daf93a2db7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91013f4dd4e2e4d3a0de3f2fe53bb60691fae3d7e76a9d35e9f5a8daf93a2db7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91013f4dd4e2e4d3a0de3f2fe53bb60691fae3d7e76a9d35e9f5a8daf93a2db7"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb0d8bcebf334502a9308918e54b45408f03fdf32265dd78b0e1324930e8b899"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3af03ed7c9ff97a8aee949496a1d8b07373d27691c7cb211c36fa216182a75c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e08838880706b11a4c513c22652ac99c8ce273551886233ce15ef88ff639971b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/clickhouse-sql-parser -format \"SELECT 1\"")
    assert_match "SELECT 1", output
  end
end
