class ClickhouseSqlParser < Formula
  desc "Writing clickhouse sql parser in pure Go"
  homepage "https://github.com/AfterShip/clickhouse-sql-parser"
  url "https://github.com/AfterShip/clickhouse-sql-parser/archive/refs/tags/v0.4.7.tar.gz"
  sha256 "af746b8a2f85210f8eea89a403be4c91174f252947843063448b754e750d9c86"
  license "MIT"
  head "https://github.com/AfterShip/clickhouse-sql-parser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5773a6060e6e403ce4646805c37e8be979db3ff9c6a25f8bbe6d8f4e9e559b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5773a6060e6e403ce4646805c37e8be979db3ff9c6a25f8bbe6d8f4e9e559b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a5773a6060e6e403ce4646805c37e8be979db3ff9c6a25f8bbe6d8f4e9e559b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3b7ddd0013448770c18151edcf77c3af7e6edc09d35982fe684f4bce84691cf"
    sha256 cellar: :any_skip_relocation, ventura:       "e3b7ddd0013448770c18151edcf77c3af7e6edc09d35982fe684f4bce84691cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c7893404fb56b2843a7417e557d0f6c2c949822aa8d6ca2a3ede70dea016af6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa7650a4ed727b4914e5ad9b2ff8916a503cdebef1d7fa3528bcba410695cf3a"
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
