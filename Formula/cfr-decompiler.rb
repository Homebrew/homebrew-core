class CfrDecompiler < Formula
  desc "Yet Another Java Decompiler"
  homepage "http://www.benf.org/other/cfr/"
  url "http://www.benf.org/other/cfr/cfr_0_128.jar"
  sha256 "3d6adb020c842cc8cb4198e7b38f256363987ba86fdb0272c1a7dcd08c0bbd26"

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
