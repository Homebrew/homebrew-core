class Pmd < Formula
  desc "Source code analyzer for Java, JavaScript, and more"
  homepage "https://pmd.github.io"
  url "https://github.com/pmd/pmd/releases/download/pmd_releases%2F7.25.0/pmd-dist-7.25.0-bin.zip"
  sha256 "1fceb3005ebfd580cc9afa5242e07df74826eedeb225f239f503083845d77fc2"
  license "BSD-4-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f4b79d4f0087eccd5bc40731eed9741b0cabc9e4143d6700967bf191f81d13e9"
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
