class Ktfmt < Formula
  desc "Kotlin code formatter"
  homepage "https://facebook.github.io/ktfmt/"
  url "https://github.com/facebook/ktfmt/archive/refs/tags/v0.64.tar.gz"
  sha256 "e36494b88d8f42aad412573fbc834e3539e66aab40dba00e5e3433a6b04f0bfc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb58fc5af9f3ded98524361f7f292136f70c7f0bfbde24e3ffa86a8e4fc5a61e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb58fc5af9f3ded98524361f7f292136f70c7f0bfbde24e3ffa86a8e4fc5a61e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb58fc5af9f3ded98524361f7f292136f70c7f0bfbde24e3ffa86a8e4fc5a61e"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb58fc5af9f3ded98524361f7f292136f70c7f0bfbde24e3ffa86a8e4fc5a61e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0ce91fcefed03a6657f5e96b03acb698e7acb960e2b1ac751abafa14b962248"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0ce91fcefed03a6657f5e96b03acb698e7acb960e2b1ac751abafa14b962248"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@17"

  def install
    ENV["JAVA_HOME"] = formula_opt_prefix("openjdk@17")

    system "gradle", "shadowJar", "--no-daemon"
    libexec.install "core/build/libs/ktfmt-#{version}-with-dependencies.jar"
    bin.write_jar_script libexec/"ktfmt-#{version}-with-dependencies.jar", "ktfmt", java_version: "17"
  end

  test do
    test_file = testpath/"Test.kt"
    test_file.write <<~KOTLIN
      fun main() { println("Hello, World!") }
    KOTLIN

    output = shell_output("#{bin}/ktfmt --google-style #{test_file} 2>&1")
    assert_match "Done formatting #{test_file}", output
    assert_equal <<~KOTLIN, test_file.read
      fun main() {
        println("Hello, World!")
      }
    KOTLIN
  end
end
