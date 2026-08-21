class ClickhouseSqlParser < Formula
  desc "Writing clickhouse sql parser in pure Go"
  homepage "https://github.com/AfterShip/clickhouse-sql-parser"
  url "https://github.com/AfterShip/clickhouse-sql-parser/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "eb839fe9dc22158e87e19bb24ee1d8719664742ebec087700cbab5785757eb4a"
  license "MIT"
  head "https://github.com/AfterShip/clickhouse-sql-parser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22200312a555530c7fe3ad1cca57679df3fe4ef2c3b6147184bddfea0b1f7651"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22200312a555530c7fe3ad1cca57679df3fe4ef2c3b6147184bddfea0b1f7651"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22200312a555530c7fe3ad1cca57679df3fe4ef2c3b6147184bddfea0b1f7651"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e7e15862a8dd87be920d5b08055ccc2788c39445cbc6c7c25c60984422efa95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a79436a512f20d0f94321fb0b54eedd6e4e240b52e5377ff6771aa28f553704"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df0d896e66468d53e26febd98ea0dac9ddff5edf9142d1ab72e5f680e0e659cb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    output = shell_output("#{bin}/clickhouse-sql-parser -format \"SELECT 1\"")
    assert_match "SELECT 1", output
  end
end
