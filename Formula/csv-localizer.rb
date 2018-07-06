class CsvLocalizer < Formula
  desc "Convert CSV file to iOS and Android localizable strings"
  homepage "https://github.com/rogermolas/csv-localizer"
  url "https://github.com/rogermolas/csv-localizer/archive/v1.2.1.tar.gz"
  sha256 "9ed12ed932673521659bee64edb9ff727c845a3a948aac00a3354b5f96a825e8"

  depends_on "python@2"

  def install
    bin.install "csv-localizer"
  end

  test do
    system "#{bin}/csv-localizer", "-h"
  end
end
