class Pmd < Formula
  desc "Source code analyzer for Java, JavaScript, and more"
  homepage "https://pmd.github.io"
  url "https://github.com/pmd/pmd/releases/download/pmd_releases%2F7.15.0/pmd-dist-7.15.0-bin.zip"
  sha256 "693776e2d39f4f24d9d5f4dc75055828dadd6671605bc7cf1246f2a277eb0b35"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5cd53a46bfc8af0d292bb49f28a6af2c6183e546afe0f788bb3598102b2a13c0"
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
