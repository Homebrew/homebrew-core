class ClickhouseSqlParser < Formula
  desc "Writing clickhouse sql parser in pure Go"
  homepage "https://github.com/AfterShip/clickhouse-sql-parser"
  url "https://github.com/AfterShip/clickhouse-sql-parser/archive/refs/tags/v0.4.18.tar.gz"
  sha256 "f0e06f1cdf2bfb1503e9678be9bc46c80ea1b142ab667591ac0d97a22a953004"
  license "MIT"
  head "https://github.com/AfterShip/clickhouse-sql-parser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12a4c8a12805e9558eff435d7310bbb0352890083ddeb078957a276d68e7673b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12a4c8a12805e9558eff435d7310bbb0352890083ddeb078957a276d68e7673b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12a4c8a12805e9558eff435d7310bbb0352890083ddeb078957a276d68e7673b"
    sha256 cellar: :any_skip_relocation, sonoma:        "507369df9597df93a67fea0c0db5dcba5112ff6211938a37f4af89ceb6cca0c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09d8fcd880dfe9806480ed2fa90e07fd985ca83c6eecbafedea8a10a48b7fc6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4521e54a2a14f0fec835927e8ab5cc0916917ee3042fad91d3720d9b0477332d"
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
