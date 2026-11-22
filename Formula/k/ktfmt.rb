class Ktfmt < Formula
  desc "Kotlin code formatter"
  homepage "https://kotlin.github.io/ktfmt/"
  url "https://github.com/Kotlin/ktfmt/archive/refs/tags/v0.65.tar.gz"
  sha256 "e03e4627481c4b078a9f3b263b486161937770ba7f9babebf938dbc06c6a7fe3"
  license "Apache-2.0"
  head "https://github.com/Kotlin/ktfmt.git", branch: "main"

  bottle do
    rebuild 1
    manifest_sha256 "8065da5a381d90ffcf47746bca095f0be1b85001986e824a41c454f56a04a4b2"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ab443fce9a9f2058516331b17ac9393c82f0e769e48d0d630f344345d327ae8e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ab443fce9a9f2058516331b17ac9393c82f0e769e48d0d630f344345d327ae8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ab443fce9a9f2058516331b17ac9393c82f0e769e48d0d630f344345d327ae8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6d6be5a4a2e3710ac9b375f4d5b0ad7c1b9f818d97e36d338b50ad9f97d30ee4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6d6be5a4a2e3710ac9b375f4d5b0ad7c1b9f818d97e36d338b50ad9f97d30ee4"
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
