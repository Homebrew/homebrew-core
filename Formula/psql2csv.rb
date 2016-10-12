class Psql2csv < Formula
  desc "Run a query in psql and output the result as CSV"
  homepage "https://github.com/fphilipe/psql2csv"
  url "https://github.com/fphilipe/psql2csv/archive/v0.9.tar.gz"
  sha256 "80dffcb2b41de131dd6023f5f496ff5981d86877de81f154f56c169793026022"
  revision 1

  bottle :unneeded

  depends_on "postgresql"

  def install
    bin.install "psql2csv"
  end

  test do
    expected = "COPY (SELECT 1) TO STDOUT WITH (FORMAT csv, ENCODING 'UTF8', HEADER true)"
    output = shell_output(%(#{bin}/psql2csv --dry-run "SELECT 1")).strip
    assert_equal expected, output
  end
end
