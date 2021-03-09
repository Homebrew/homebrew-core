class ExcelCompare < Formula
  desc "Command-line tool (and API) for diffing Excel Workbooks"
  homepage "https://github.com/na-ka-na/ExcelCompare"
  url "https://github.com/na-ka-na/ExcelCompare/releases/download/0.6.1/ExcelCompare-0.6.1.zip"
  sha256 "9da80954db03f23ebcb6571fdd24520a020a0ea05f46fbe4aba8e2af54c6048c"
  license "MIT"

  bottle :unneeded

  resource "sample_workbook" do
    url "https://github.com/na-ka-na/ExcelCompare/raw/0.6.1/test/resources/ss1.xlsx"
    sha256 "f362153aea24092e45a3d306a16a49e4faa19939f83cdcb703a215fe48cc196a"
  end

  def install
    libexec.install Dir["bin/dist/*"]

    (bin/"excel_cmp").write <<~EOS
      #!/bin/sh
      java -ea -Xmx512m -cp "#{libexec}/*" com.ka.spreadsheet.diff.SpreadSheetDiffer "$@"
    EOS
  end

  test do
    resource("sample_workbook").stage testpath
    assert_match %r{Excel files #{testpath}/ss1.xlsx and #{testpath}/ss1.xlsx match},
      shell_output("#{bin}/excel_cmp #{testpath}/ss1.xlsx #{testpath}/ss1.xlsx")
  end
end
