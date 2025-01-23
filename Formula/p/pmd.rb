class Pmd < Formula
  desc "Source code analyzer for Java, JavaScript, and more"
  homepage "https://pmd.github.io"
  url "https://github.com/pmd/pmd/releases/download/pmd_releases%2F7.9.0/pmd-dist-7.9.0-bin.zip"
  sha256 "dcb363fe20c2cc6faa700f3bf49034ef29b9a18f8892530d425a3f3b15eeea0d"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4d912e23fb493a60b74bb6bd653fc869dfb3fdb69df632541f400470aab2e2b5"
  end

  depends_on "openjdk"

  def install
    rm Dir["bin/*.bat"]
    libexec.install Dir["*"]
    (bin/"pmd").write_env_script libexec/"bin/pmd", Language::Java.overridable_java_home_env
  end

  test do
    (testpath/"java/testClass.java").write <<~JAVA
      public class BrewTestClass {
        // dummy constant
        public String SOME_CONST = "foo";

        public boolean doTest () {
          return true;
        }
      }
    JAVA

    output = shell_output("#{bin}/pmd check -d #{testpath}/java " \
                          "-R category/java/bestpractices.xml -f json")
    assert_empty JSON.parse(output)["processingErrors"]
  end
end
