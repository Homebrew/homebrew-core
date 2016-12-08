class ExcelCompare < Formula
  desc "Command-line tool (and API) for diffing Excel Workbooks"
  homepage "https://github.com/na-ka-na/ExcelCompare"
  url "https://github.com/na-ka-na/ExcelCompare/releases/download/0.6.0/ExcelCompare-0.6.0.zip"
  sha256 "63bda982644ec8633b60eed5bc199892c428b54addb2eb63dda0b894d98a56c4"

  def install
    libexec.install Dir["bin/dist/*"]

    (bin/"excel_cmp").write <<-EOS.undent
      #!/bin/sh
      java -ea -Xmx512m -cp "#{libexec}/*" com.ka.spreadsheet.diff.SpreadSheetDiffer "$@"
    EOS
  end

  test do
    assert_match /Usage> excel_cmp/, shell_output("#{bin}/excel_cmp --help", 255)
  end
end
