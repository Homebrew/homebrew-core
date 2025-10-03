class ClickhouseSqlParser < Formula
  desc "Writing clickhouse sql parser in pure Go"
  homepage "https://github.com/AfterShip/clickhouse-sql-parser"
  url "https://github.com/AfterShip/clickhouse-sql-parser/archive/refs/tags/v0.4.13.tar.gz"
  sha256 "66594646ed01db21f853aac3493081555185d44f429a3ccc215708b7944d277d"
  license "MIT"
  head "https://github.com/AfterShip/clickhouse-sql-parser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f20e08308fcdaa0ea7c958febdf5e3f30f3ebd4b3734447fc8ce2af5f99d3f33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f20e08308fcdaa0ea7c958febdf5e3f30f3ebd4b3734447fc8ce2af5f99d3f33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f20e08308fcdaa0ea7c958febdf5e3f30f3ebd4b3734447fc8ce2af5f99d3f33"
    sha256 cellar: :any_skip_relocation, sonoma:        "703cb6e4ab09502020fba7be872342a30f9a965cb6db3eb780253bc0043798ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22f946e51e4c69f497e33e9813d81ac1f2b206c132e674ca0d4b2546ca64bdd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23b4562e0a72da288b0fc800feb2c8b0e1a7613518912a0b20ce3292edfd2392"
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
