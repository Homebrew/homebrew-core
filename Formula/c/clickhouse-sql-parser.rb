class ClickhouseSqlParser < Formula
  desc "Writing clickhouse sql parser in pure Go"
  homepage "https://github.com/AfterShip/clickhouse-sql-parser"
  url "https://github.com/AfterShip/clickhouse-sql-parser/archive/refs/tags/v0.4.17.tar.gz"
  sha256 "cc9ed39d1b1a4ad898df8d5c7aacc29135c018577788c4b5d5832832066b143a"
  license "MIT"
  head "https://github.com/AfterShip/clickhouse-sql-parser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10da1b67011e637ab740a47a58deaf12732010fc0a502638f34f40c2873ad740"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10da1b67011e637ab740a47a58deaf12732010fc0a502638f34f40c2873ad740"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10da1b67011e637ab740a47a58deaf12732010fc0a502638f34f40c2873ad740"
    sha256 cellar: :any_skip_relocation, sonoma:        "d58be9a5aa62e192a4f951979f152d230c62e1bdf3a613991567a5da16843b5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9fc6d00fb425c1888acfdcc58cc8b4b1c0f346756e9b43e4eb1473303f67ca8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af928c357856032ce2b9af165ea7017e094d1ae6ebbf331273afaf2c02ad9447"
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
