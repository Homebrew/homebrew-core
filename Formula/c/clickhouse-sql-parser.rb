class ClickhouseSqlParser < Formula
  desc "Writing clickhouse sql parser in pure Go"
  homepage "https://github.com/AfterShip/clickhouse-sql-parser"
  url "https://github.com/AfterShip/clickhouse-sql-parser/archive/refs/tags/v0.4.19.tar.gz"
  sha256 "f633b4e68ada4b3168592005c81c5550afba77012b6f812d2e01acdace83d0fd"
  license "MIT"
  head "https://github.com/AfterShip/clickhouse-sql-parser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96acd78821946c7970be95227c68d68a5232e6a6b15148f96a5bb9e593c5f7ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96acd78821946c7970be95227c68d68a5232e6a6b15148f96a5bb9e593c5f7ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96acd78821946c7970be95227c68d68a5232e6a6b15148f96a5bb9e593c5f7ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ea851c12b69401e5b89e17c25de3e0b8d972a4d0a1ec9bd9e334ade4e0632cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a845d111fa897a78b0f03fe1ea39afa02ddd34fe5a4a10060c78fb0519c4d40d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d35ae72cc04d8c4354f5184881bda229338aa8a151704253daa42ae27283831"
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
