class Ktfmt < Formula
  desc "Kotlin code formatter"
  homepage "https://facebook.github.io/ktfmt/"
  url "https://github.com/facebook/ktfmt/archive/refs/tags/v0.65.tar.gz"
  sha256 "e03e4627481c4b078a9f3b263b486161937770ba7f9babebf938dbc06c6a7fe3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b4aa1152a307cb05ee4dce1f7ef509ef6cdaa3e702838158b5ce8ed262934932"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b4aa1152a307cb05ee4dce1f7ef509ef6cdaa3e702838158b5ce8ed262934932"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b4aa1152a307cb05ee4dce1f7ef509ef6cdaa3e702838158b5ce8ed262934932"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3609720980ff5ea77b551f7fe133e21fc4e04b27e1a03aaf16d1f62af6f19341"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3609720980ff5ea77b551f7fe133e21fc4e04b27e1a03aaf16d1f62af6f19341"
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
