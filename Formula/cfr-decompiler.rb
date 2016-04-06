class CfrDecompiler < Formula
  desc "Yet Another Java Decompiler."
  homepage "http://www.benf.org/other/cfr/"
  url "http://www.benf.org/other/cfr/cfr_0_115.jar"
  sha256 "776fef3765d90a1e5d1d501c59ce7b2a8fae0a5d1d756bd5d199d087b423d926"

  bottle :unneeded

  depends_on :java => "1.6+"

  def install
    jar_version = version.to_s.tr(".", "_")
    libexec.install "cfr_#{jar_version}.jar"
    bin.write_jar_script libexec/"cfr_#{jar_version}.jar", "cfr-decompiler"
  end

  test do
    fixture = <<-EOS.undent
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
