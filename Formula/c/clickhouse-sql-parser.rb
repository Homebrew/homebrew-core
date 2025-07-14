class ClickhouseSqlParser < Formula
  desc "Writing clickhouse sql parser in pure Go"
  homepage "https://github.com/AfterShip/clickhouse-sql-parser"
  url "https://github.com/AfterShip/clickhouse-sql-parser/archive/refs/tags/v0.4.10.tar.gz"
  sha256 "548e5ba211323e45c55dd4a28184ef8851d5c21ee0b69f07254e3a87101ab19f"
  license "MIT"
  head "https://github.com/AfterShip/clickhouse-sql-parser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13b064263549c6713c801088ef8c274ec93a6cb8d7336e08816fd8841cac4b99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13b064263549c6713c801088ef8c274ec93a6cb8d7336e08816fd8841cac4b99"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13b064263549c6713c801088ef8c274ec93a6cb8d7336e08816fd8841cac4b99"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bc9845a3656de9d013bebcb0bd30f809cc6c2639a4baeb4626a5e347139370c"
    sha256 cellar: :any_skip_relocation, ventura:       "3bc9845a3656de9d013bebcb0bd30f809cc6c2639a4baeb4626a5e347139370c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54174fb64eaeaf654fc8c16acc37f4f8f41b1f61f6260c2014cad285e3377503"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0632d9623e1e572bb8269be6cbf139093533332db6aede7ca7a1a8113267643"
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
