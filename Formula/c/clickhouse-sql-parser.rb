class ClickhouseSqlParser < Formula
  desc "Clickhous-sql-parser is a clickHouse sql parser writing in Go"
  homepage "https://github.com/AfterShip/clickhouse-sql-parser"
  url "https://github.com/AfterShip/clickhouse-sql-parser/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "6123b8e0cf5f1a6af28fb9a07e66bf1b3db30fea2207ac949374a0420e10dd40"
  license "MIT"
  head "https://github.com/AfterShip/clickhouse-sql-parser", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba9e227edc8b3b91c084afcc101591b6de25c92ca26975c47671f0b48894eb13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18706d8cbe1851b9964d4b4441a0bf06f311f1194ab44047ca53952f31ffba70"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6eb228d6c935ab833ce55e3f5cf2f17babbcb4876161bbb3716f7f1cb7b0a53"
    sha256 cellar: :any_skip_relocation, ventura:        "f9208c938ebb59f6207a1cadf7201ae79ea82c4acee41c600c9ced000fa032cd"
    sha256 cellar: :any_skip_relocation, monterey:       "1c11676602b3d1f379d9a1c8988a363b926ba567f34dfabf7e9b27b28dae4cf4"
    sha256 cellar: :any_skip_relocation, big_sur:        "0387c815afa7034f59733f11893b2ed9c70d5f748c48d99d81b2ab34f0445769"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "148565d1b744350c2422670c8aba16f61b7c07e9a10a1bb9be36ce370d4821ce"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    output = shell_output("#{bin}/clickhouse-sql-parser -v 2>&1")
    assert_match "v#{version}", output
  end
end
