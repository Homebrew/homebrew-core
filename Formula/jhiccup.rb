class Jhiccup < Formula
  desc "Measure pauses and stalls of an app's Java runtime platform"
  homepage "https://www.azul.com/products/open-source-tools/jhiccup-performance-measurement-tool/"
  url "https://www.azulsystems.com/sites/default/files/images/jHiccup.1.3.7.zip"
  sha256 "abc029bfb55bbe59824d0b6db6845bd0f08befba3b860747ed601a6c27573f24"

  bottle :unneeded

  def install
    bin.install "jHiccup"

    # Simple script to create and open a new plotter spreadsheet
    (bin+"jHiccupPlotter").write <<~EOS
      #!/bin/sh
      TMPFILE="/tmp/jHiccupPlotter.$$.xls"
      cp "#{prefix}/jHiccupPlotter.xls" $TMPFILE
      open $TMPFILE
    EOS

    prefix.install "target"
    prefix.install "jHiccupPlotter.xls"
    inreplace "#{bin}/jHiccup" do |s|
      s.gsub! /^JHICCUP_JAR_FILE=.*$/,
              "JHICCUP_JAR_FILE=#{prefix}/target/jHiccup.jar"
    end
  end
end
