class Pmd < Formula
  desc "Source code analyzer for Java, JavaScript, and more"
  homepage "https://pmd.github.io"
  url "https://github.com/pmd/pmd/releases/download/pmd_releases%2F7.4.0/pmd-dist-7.4.0-bin.zip"
  sha256 "1dcbb7784a7fba1fd3c6efbaf13dcb63f05fe069fcf026ad5e2933711ddf5026"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "27df33d6de57b1f75f7be19f9e1cb5062815d3c52adb2477a201b60f251f884d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27df33d6de57b1f75f7be19f9e1cb5062815d3c52adb2477a201b60f251f884d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27df33d6de57b1f75f7be19f9e1cb5062815d3c52adb2477a201b60f251f884d"
    sha256 cellar: :any_skip_relocation, sonoma:         "27df33d6de57b1f75f7be19f9e1cb5062815d3c52adb2477a201b60f251f884d"
    sha256 cellar: :any_skip_relocation, ventura:        "27df33d6de57b1f75f7be19f9e1cb5062815d3c52adb2477a201b60f251f884d"
    sha256 cellar: :any_skip_relocation, monterey:       "27df33d6de57b1f75f7be19f9e1cb5062815d3c52adb2477a201b60f251f884d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0dd600b67eaeb7142de161aa826589a3e95a1764fd2de7ea3dfc95d9df6e0d0"
  end

  depends_on "openjdk"

  def install
    rm Dir["bin/*.bat"]
    libexec.install Dir["*"]
    (bin/"pmd").write_env_script libexec/"bin/pmd", Language::Java.overridable_java_home_env
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

    output = shell_output("#{bin}/pmd check -d #{testpath}/java " \
                          "-R category/java/bestpractices.xml -f json")
    assert_empty JSON.parse(output)["processingErrors"]
  end
end
