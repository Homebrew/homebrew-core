class ClickhouseSqlParser < Formula
  desc "Writing clickhouse sql parser in pure Go"
  homepage "https://github.com/AfterShip/clickhouse-sql-parser"
  url "https://github.com/AfterShip/clickhouse-sql-parser/archive/refs/tags/v0.5.7.tar.gz"
  sha256 "342b64a3a74333a6c711531c7d6cff3d7bfa225f8d04103e51884faf2d14e38b"
  license "MIT"
  head "https://github.com/AfterShip/clickhouse-sql-parser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2b000bb3f6dba44f7fd9dea47ab629bd852d03fb781d3af36278319026eedf1d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2b000bb3f6dba44f7fd9dea47ab629bd852d03fb781d3af36278319026eedf1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2b000bb3f6dba44f7fd9dea47ab629bd852d03fb781d3af36278319026eedf1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "173d4552d89e22584feec34c01836678f2084c3a478dfd8310861f96d918f43e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d8a77831b2e6dc04d4e48bbf1e5dc1725b5a334a92ec865d9a4ea7528d5c5d2f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    output = shell_output("#{bin}/clickhouse-sql-parser -format \"SELECT 1\"")
    assert_match "SELECT 1", output
  end
end
