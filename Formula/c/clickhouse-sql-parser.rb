class ClickhouseSqlParser < Formula
  desc "Writing clickhouse sql parser in pure Go"
  homepage "https://github.com/AfterShip/clickhouse-sql-parser"
  url "https://github.com/AfterShip/clickhouse-sql-parser/archive/refs/tags/v0.4.8.tar.gz"
  sha256 "227b6f461fe23105bb34c4408808cf92f9706d814b06e2943c0840c04ca3e36f"
  license "MIT"
  head "https://github.com/AfterShip/clickhouse-sql-parser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0489478f1a7f6b18053f924450986c550e938b4c2da979beb57c9ba7c202ed0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0489478f1a7f6b18053f924450986c550e938b4c2da979beb57c9ba7c202ed0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0489478f1a7f6b18053f924450986c550e938b4c2da979beb57c9ba7c202ed0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "faa7fa2fec86178cf2c617de780dcf3427894bc9b2d6675ac6e913e7d4e04056"
    sha256 cellar: :any_skip_relocation, ventura:       "faa7fa2fec86178cf2c617de780dcf3427894bc9b2d6675ac6e913e7d4e04056"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7780067b08e1c7136bc0bd0c04c3863a8d25e9e615a01508ecb80a440362cbb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63afe8b89177dcf36d986fdff490d00cd2bba98c275e3f6f7cd1a24e8bce6981"
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
