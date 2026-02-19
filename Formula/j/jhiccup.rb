class Jhiccup < Formula
  desc "Measure pauses and stalls of an app's Java runtime platform"
  homepage "https://www.azul.com/products/components/jhiccup/"
  url "https://www.azul.com/files/jHiccup-2.0.10-dist.zip"
  sha256 "7bb1145d211d140b4f81184df7eb9cea90f56720ad7504fac43c0c398f38a7d8"
  license any_of: ["CC0-1.0", "BSD-2-Clause"]

  livecheck do
    url :homepage
    regex(/href=.*?jHiccup[._-]v?(\d+(?:\.\d+)+)-dist(?:-\d+)?\.zip/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "010529211ca43ed531a37e60a1c33ee7a38b823038d204992713461c4ef4b56c"
  end

  def install
    bin.install "jHiccup", "jHiccupLogProcessor"

    # Simple script to create and open a new plotter spreadsheet
    (bin/"jHiccupPlotter").write <<~EOS
      #!/bin/sh
      TMPFILE="/tmp/jHiccupPlotter.$$.xls"
      cp "#{prefix}/jHiccupPlotter.xls" $TMPFILE
      open $TMPFILE
    EOS

    prefix.install "jHiccup.jar"
    prefix.install "jHiccupPlotter.xls"
    inreplace "#{bin}/jHiccup" do |s|
      s.gsub!(/^JHICCUP_JAR_FILE=.*$/,
              "JHICCUP_JAR_FILE=#{prefix}/jHiccup.jar")
    end
  end

  test do
    assert_match "CSV", shell_output("#{bin}/jHiccup -h", 255)
  end
end
