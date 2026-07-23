class ClickhouseSqlParser < Formula
  desc "Writing clickhouse sql parser in pure Go"
  homepage "https://github.com/AfterShip/clickhouse-sql-parser"
  url "https://github.com/AfterShip/clickhouse-sql-parser/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "bc1eca7da4ba60426a5434df69d353aec543fe1e69486f0d3cbec26ca820b266"
  license "MIT"
  head "https://github.com/AfterShip/clickhouse-sql-parser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f335e61a9f1619e006df73a1088e2d2e509665acd59c59571353b7d831d3f9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f335e61a9f1619e006df73a1088e2d2e509665acd59c59571353b7d831d3f9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f335e61a9f1619e006df73a1088e2d2e509665acd59c59571353b7d831d3f9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd6e7ec2fc0b67232181e1ce86a401adba6cde3d4902f25e11c57624167d87f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2e24e94574e27d9c72cb6d4fa7b7e7762f9ff1b9c6c10a9a165d4d2665e66e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6262ca505e2d053fc8af7c24a0285cde97f763a78f95a78881ab1b1d46009ec"
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
