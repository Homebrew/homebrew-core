class ClickhouseSqlParser < Formula
  desc "Writing clickhouse sql parser in pure Go"
  homepage "https://github.com/AfterShip/clickhouse-sql-parser"
  url "https://github.com/AfterShip/clickhouse-sql-parser/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "1f946e3ca4256d7aba68d6c185a53039206b4f0b08ee5b50228bad64e9bef0a4"
  license "MIT"
  head "https://github.com/AfterShip/clickhouse-sql-parser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94861e44e92d753d428f8d2cc507ed838478f8cbed73b27b8be39af98a1ab842"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94861e44e92d753d428f8d2cc507ed838478f8cbed73b27b8be39af98a1ab842"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "94861e44e92d753d428f8d2cc507ed838478f8cbed73b27b8be39af98a1ab842"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef16c5901e2f8be415d8e362b57832fcf39ef8f8998f80897f053f02d1786259"
    sha256 cellar: :any_skip_relocation, ventura:       "ef16c5901e2f8be415d8e362b57832fcf39ef8f8998f80897f053f02d1786259"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1020fed1331889a1d5fe02b94d811b5917054662501dd6836db8cc637408f468"
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
