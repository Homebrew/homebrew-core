class CfrDecompiler < Formula
  desc "Yet Another Java Decompiler"
  homepage "https://www.benf.org/other/cfr/"
  url "https://www.benf.org/other/cfr/cfr-0.139.jar"
  sha256 "d30e830b761638d86908c9b622d9ec1105ffb33e8cd40cf1496662086a782a72"

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
