class CfrDecompiler < Formula
  desc "Yet Another Java Decompiler"
  homepage "https://www.benf.org/other/cfr/"
  url "https://www.benf.org/other/cfr/cfr-0.146.jar"
  sha256 "6cc41ece70cb463e0a830fe9d68c22836d9eef5c5f7da1d6e8002c08f5b0f59a"

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
