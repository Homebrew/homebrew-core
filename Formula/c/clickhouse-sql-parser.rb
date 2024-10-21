class ClickhouseSqlParser < Formula
  desc "Writing clickhouse sql parser in pure Go"
  homepage "https://github.com/AfterShip/clickhouse-sql-parser"
  url "https://github.com/AfterShip/clickhouse-sql-parser/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "dda8b9503bf0e71d78fce260dcf3c72b2929580d554a7e4d03bbb4177c63868b"
  license "MIT"
  head "https://github.com/AfterShip/clickhouse-sql-parser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6114fb827bbad3d03c5efdd0a582bd8aa4cb40345a09153832cc86e8e885318d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6114fb827bbad3d03c5efdd0a582bd8aa4cb40345a09153832cc86e8e885318d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6114fb827bbad3d03c5efdd0a582bd8aa4cb40345a09153832cc86e8e885318d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6df5a42f84e9d324251a002a452a1605458d965bdd1c9447e15aab45026f83f5"
    sha256 cellar: :any_skip_relocation, ventura:       "6df5a42f84e9d324251a002a452a1605458d965bdd1c9447e15aab45026f83f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8b557c9f468a66e860ea8d073fcb25a2f334031d819f0c13520e028f5ff9ce4"
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
