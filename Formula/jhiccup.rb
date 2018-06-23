class Jhiccup < Formula
  desc "Measure pauses and stalls of an app's Java runtime platform"
  homepage "https://www.azul.com/jhiccup/"
  url "https://www.azul.com/files/jHiccup-2.0.9-dist.zip"
  sha256 "110b10d89c310467a1d77c9d44e5ae94370ea76ed1f925bb515352038316a78c"

  bottle :unneeded

  def install
    bin.install "jHiccup", "jHiccupLogProcessor"

    # Simple script to create and open a new plotter spreadsheet
    (bin+"jHiccupPlotter").write <<~EOS
      #!/bin/sh
      TMPFILE="/tmp/jHiccupPlotter.$$.xls"
      cp "#{prefix}/jHiccupPlotter.xls" $TMPFILE
      open $TMPFILE
    EOS

    prefix.install "jHiccup.jar"
    prefix.install "jHiccupPlotter.xls"
    inreplace "#{bin}/jHiccup" do |s|
      s.gsub! /^JHICCUP_JAR_FILE=.*$/,
              "JHICCUP_JAR_FILE=#{prefix}/jHiccup.jar"
    end
  end

  test do
    assert_match "CSV", shell_output("#{bin}/jHiccup -h", 255)
  end
end
