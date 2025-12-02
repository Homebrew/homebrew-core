class Psql2csv < Formula
  desc "Run a query in psql and output the result as CSV"
  homepage "https://github.com/fphilipe/psql2csv"
  url "https://github.com/fphilipe/psql2csv/archive/refs/tags/v0.12.tar.gz"
  sha256 "bd99442ee5b6892589986cb93f928ec9e823d17d06f10c8e74e7522bf021ca28"
  license "MIT"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "2bd408af21ea8fd340ab8a95d11c4a0b0d0c106a2aa9b87cdd9d8f4c09390290"
  end

  depends_on "libpq"

  def install
    bin.install "psql2csv"
  end

  test do
    expected = "COPY (SELECT 1) TO STDOUT WITH (FORMAT csv, ENCODING 'UTF8', HEADER true)"
    output = shell_output(%Q(#{bin}/psql2csv --dry-run "SELECT 1")).strip
    assert_equal expected, output
  end
end
