class ExcelCompare < Formula
  desc "Command-line tool (and API) for diffing Excel Workbooks"
  homepage "https://github.com/na-ka-na/ExcelCompare"
  url "https://github.com/na-ka-na/ExcelCompare/releases/download/0.7.0/ExcelCompare-0.7.0.zip"
  sha256 "bf5709fc7c86a59f6f535685b0e08a7c8bcb73c48c4c03e4d54b1fd816c90825"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "a711cca888cc9038f1b3d57586bd777495e17e849ff0fc5577d10cfca5bd329a"
  end

  depends_on "openjdk"

  resource "sample_workbook" do
    url "https://github.com/na-ka-na/ExcelCompare/raw/0.7.0/src/test/resources/ss1.xlsx"
    sha256 "f362153aea24092e45a3d306a16a49e4faa19939f83cdcb703a215fe48cc196a"
  end

  def install
    libexec.install Dir["lib/*"]

    (bin/"excel_cmp").write <<~EOS
      #!/bin/bash
      export JAVA_HOME="${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
      exec "${JAVA_HOME}/bin/java" -ea -cp "#{libexec}/*" com.ka.spreadsheet.diff.SpreadSheetDiffer "$@"
    EOS
  end

  test do
    resource("sample_workbook").stage testpath
    assert_match %r{Excel files #{testpath}/ss1.xlsx and #{testpath}/ss1.xlsx match},
      shell_output("#{bin}/excel_cmp #{testpath}/ss1.xlsx #{testpath}/ss1.xlsx")
  end
end
