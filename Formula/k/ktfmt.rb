class Ktfmt < Formula
  desc "Kotlin code formatter"
  homepage "https://kotlin.github.io/ktfmt/"
  url "https://github.com/Kotlin/ktfmt/archive/refs/tags/v0.65.1.tar.gz"
  sha256 "2895b71e2ebf144189cbd778a3d260269b8ab9de4752e8efe1318af2be7e6f96"
  license "Apache-2.0"
  head "https://github.com/Kotlin/ktfmt.git", branch: "main"

  bottle do
    manifest_sha256 "542e054149375027ff3afafd76e8ad7c228acff87202f4d11270df341ff523d5"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "52db0efa58e3f9bd27fdd707f73ed3a2fb94d3b1919754998cb933a70c7afcc0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "52db0efa58e3f9bd27fdd707f73ed3a2fb94d3b1919754998cb933a70c7afcc0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "52db0efa58e3f9bd27fdd707f73ed3a2fb94d3b1919754998cb933a70c7afcc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "07ab245d48f3e3e6438c20ab6ae3515f4cc9227ca61e70ce455180a3d7a6a4e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "07ab245d48f3e3e6438c20ab6ae3515f4cc9227ca61e70ce455180a3d7a6a4e8"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  allow_network_access! :build

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home

    system "gradle", "shadowJar", "--no-daemon"
    libexec.install "core/build/libs/ktfmt-#{version}-with-dependencies.jar"
    bin.write_jar_script libexec/"ktfmt-#{version}-with-dependencies.jar", "ktfmt"
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
