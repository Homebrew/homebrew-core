class Pmd < Formula
  desc "Source code analyzer for Java, JavaScript, and more"
  homepage "https://pmd.github.io"
  url "https://github.com/pmd/pmd/releases/download/pmd_releases/6.39.0/pmd-bin-6.39.0.zip"
  sha256 "3831a51241c38285e4c0e375e844a2195c0dc5216d7247ffe12f2ab3fced64fd"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cf8b9b7304b9a7718cfd482887ab25e952f4b7427b455eb487c52cd16c7fa98a"
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
