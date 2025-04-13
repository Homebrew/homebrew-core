class ClickhouseSqlParser < Formula
  desc "Writing clickhouse sql parser in pure Go"
  homepage "https://github.com/AfterShip/clickhouse-sql-parser"
  url "https://github.com/AfterShip/clickhouse-sql-parser/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "da55449639e7e745127eea1f1568e7d5cbf3ed54d78fadeaf8b684eda188ce9e"
  license "MIT"
  head "https://github.com/AfterShip/clickhouse-sql-parser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b8e2310f066f9105c89c44462988e4df759e4adef8eb8ad0a6be3d667c205a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b8e2310f066f9105c89c44462988e4df759e4adef8eb8ad0a6be3d667c205a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b8e2310f066f9105c89c44462988e4df759e4adef8eb8ad0a6be3d667c205a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "dba203f1b092c4e873145ab439a73ff5c42b51c7861f6d0454db29af2c66c627"
    sha256 cellar: :any_skip_relocation, ventura:       "dba203f1b092c4e873145ab439a73ff5c42b51c7861f6d0454db29af2c66c627"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30bfd56235d75ce1d50a1f65538d1f4b62ece944a487e9da0bb061f3cd0909fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bece39493f2123cec98c243194bb829da8d10ec70804ff120bfadb6e10ce766"
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
