class CfrDecompiler < Formula
  desc "Yet Another Java Decompiler"
  homepage "https://www.benf.org/other/cfr/"
  url "https://www.benf.org/other/cfr/cfr-0.147.jar"
  sha256 "9a22ca2f882286912f331f1b2f5647f3a200f5314aa8e836cf67021afbee4ef5"

  bottle :unneeded

  depends_on :java => "1.6+"

  def install
    libexec.install "cfr-#{version}.jar"
    bin.write_jar_script libexec/"cfr-#{version}.jar", "cfr-decompiler"
  end

  test do
    fixture = <<~EOS
      import java.io.PrintStream;

      class T {
          T() {
          }

          public static void main(String[] arrstring) {
              System.out.println("Hello brew!");
          }
      }
    EOS
    (testpath/"T.java").write fixture
    system "javac", "T.java"
    output = pipe_output("#{bin}/cfr-decompiler T.class")
    assert_match fixture, output
  end
end
