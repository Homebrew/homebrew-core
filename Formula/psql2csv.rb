class Psql2csv < Formula
  desc "Run a query in psql and output the result as CSV"
  homepage "https://github.com/fphilipe/psql2csv"
  url "https://github.com/fphilipe/psql2csv/archive/v0.11.tar.gz"
  sha256 "f961c3ca980ce4b527a0d86b593c73fbf244829a20ab7df343e1c077818ddba0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9c6880c0b5911b3d8bbc35d5076acd31742f1a09238fc8404501dcb5ffb2bc35"
  end

  depends_on "postgresql"

  def install
    bin.install "psql2csv"
  end

  test do
    expected = "COPY (SELECT 1) TO STDOUT WITH (FORMAT csv, ENCODING 'UTF8', HEADER true)"
    output = shell_output(%Q(#{bin}/psql2csv --dry-run "SELECT 1")).strip
    assert_equal expected, output
  end
end
