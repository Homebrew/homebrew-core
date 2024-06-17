class Pmd < Formula
  desc "Source code analyzer for Java, JavaScript, and more"
  homepage "https://pmd.github.io"
  url "https://github.com/pmd/pmd/releases/download/pmd_releases%2F7.2.0/pmd-dist-7.2.0-bin.zip"
  sha256 "2dfee533351069816870c3fc1ea3b3089f0fea602748b0d8ab9db1f0c381ded2"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f8947acf64627ef6dde887d3b9faa5a16ebf81504d0964d29b7d8698b0ceb7dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8947acf64627ef6dde887d3b9faa5a16ebf81504d0964d29b7d8698b0ceb7dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8947acf64627ef6dde887d3b9faa5a16ebf81504d0964d29b7d8698b0ceb7dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8947acf64627ef6dde887d3b9faa5a16ebf81504d0964d29b7d8698b0ceb7dd"
    sha256 cellar: :any_skip_relocation, ventura:        "f8947acf64627ef6dde887d3b9faa5a16ebf81504d0964d29b7d8698b0ceb7dd"
    sha256 cellar: :any_skip_relocation, monterey:       "f8947acf64627ef6dde887d3b9faa5a16ebf81504d0964d29b7d8698b0ceb7dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "084d5f8d7cb841daa6880f350e1d8e4564c1ed294a57761a001316044df74c40"
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
