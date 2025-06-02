class ClickhouseSqlParser < Formula
  desc "Writing clickhouse sql parser in pure Go"
  homepage "https://github.com/AfterShip/clickhouse-sql-parser"
  url "https://github.com/AfterShip/clickhouse-sql-parser/archive/refs/tags/v0.4.9.tar.gz"
  sha256 "4432b7d415c21249df05909c5f682dc503233aff78550c83c0ce64ccd0ae9afd"
  license "MIT"
  head "https://github.com/AfterShip/clickhouse-sql-parser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "386b26d4f173d87aca01be01e3617f35175c4f472e86b1dd4a7b473ef7dcb9f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "386b26d4f173d87aca01be01e3617f35175c4f472e86b1dd4a7b473ef7dcb9f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "386b26d4f173d87aca01be01e3617f35175c4f472e86b1dd4a7b473ef7dcb9f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed0cf23a7e7c2cd45a050ded92753696ebb39b27276206332a2605b641ef6d3e"
    sha256 cellar: :any_skip_relocation, ventura:       "ed0cf23a7e7c2cd45a050ded92753696ebb39b27276206332a2605b641ef6d3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e218b79aedd7ba522b563d75497b4607c4e0d30800aa4d5f56fc948c91afee6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f2309430e4831e8674411a759386f8f9da146b2eda4872f22186163ffa8697b"
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
