class Pmd < Formula
  desc "Source code analyzer for Java, JavaScript, and more"
  homepage "https://pmd.github.io"
  url "https://github.com/pmd/pmd/releases/download/pmd_releases%2F7.12.0/pmd-dist-7.12.0-bin.zip"
  sha256 "418dd819d38a16a49d7f345ef9a0a51e9f53e99f022d8b0722de77b7049bb8b8"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "960a16b1eb36da62837fdad98957d34a596b8a51b1ab9444f9c652853264ac47"
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
