class CfrDecompiler < Formula
  desc "Yet Another Java Decompiler"
  homepage "http://www.benf.org/other/cfr/"
  url "http://www.benf.org/other/cfr/cfr_0_125.jar"
  sha256 "8aab66c335c2ba34844d95f45262f9a4706fff31b50e8a24dacbb3745e6ba9a9"

  bottle :unneeded

  depends_on :java => "1.6+"

  def install
    jar_version = version.to_s.tr(".", "_")
    libexec.install "cfr_#{jar_version}.jar"
    bin.write_jar_script libexec/"cfr_#{jar_version}.jar", "cfr-decompiler"
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
