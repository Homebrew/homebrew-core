class Pmd < Formula
  desc "Source code analyzer for Java, JavaScript, and more"
  homepage "https://pmd.github.io"
  url "https://github.com/pmd/pmd/releases/download/pmd_releases/6.38.0/pmd-bin-6.38.0.zip"
  sha256 "bc316327421367fd33a9fe3655d10aea1486d01e744a0f9096e3bf7a869664e8"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3f960cf4ebfb1cdf7ccbbf15480e40d05f4ad23bf7e5217d12e6f6ea3354f5e4"
  end

  depends_on "openjdk"

  def install
    rm Dir["bin/*.bat"]
    libexec.install Dir["*"]
    (bin/"pmd").write_env_script libexec/"bin/run.sh", Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
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
