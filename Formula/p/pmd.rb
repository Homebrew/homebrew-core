class Pmd < Formula
  desc "Source code analyzer for Java, JavaScript, and more"
  homepage "https://pmd.github.io"
  url "https://github.com/pmd/pmd/releases/download/pmd_releases%2F7.22.0/pmd-dist-7.22.0-bin.zip"
  sha256 "bff3d69dad69c3526ae04b94d12b3f4c5d7c90421cde8b4e8d836a30176f55c4"
  license "BSD-4-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "abce4b4128e07d4278928da26fd08a007e9da57ac49f3406230da5e27c3b2151"
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
