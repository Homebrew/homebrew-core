class Pmd < Formula
  desc "Source code analyzer for Java, JavaScript, and more"
  homepage "https://pmd.github.io"
  url "https://github.com/pmd/pmd/releases/download/pmd_releases/6.13.0/pmd-bin-6.13.0.zip"
  sha256 "2ccb17a3b9845679e310a68a7f1d328feabc12668e774b0496e0f8ef0ab8df7d"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    rm Dir["bin/*.bat"]
    libexec.install Dir["*"]
    (bin/"pmd").write_env_script libexec/"bin/run.sh",
                                 Language::Java.java_home_env("1.8+")
  end

  def caveats; <<~EOS
    Run with `pmd` (instead of `run.sh` as described in the documentation).
  EOS
  end

  test do
    (testpath/"java/testClass.java").write <<~EOS
      public class BrewTestClass {
        // dummy constant
        public String SOME_CONST = "foo";

        public boolean doTest () {
          return true;
        }
      }
    EOS

    system "#{bin}/pmd", "pmd", "-d", "#{testpath}/java", "-R",
      "rulesets/java/basic.xml", "-f", "textcolor", "-l", "java"
  end
end
