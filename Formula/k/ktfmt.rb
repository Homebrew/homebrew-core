class Ktfmt < Formula
  desc "Kotlin code formatter"
  homepage "https://facebook.github.io/ktfmt/"
  url "https://github.com/facebook/ktfmt/archive/refs/tags/v0.59.tar.gz"
  sha256 "46941aee1993a1b8ac9ef8f586543e635f7349a5a62ad8993a11dc2d8d6b0a59"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "37d202f7143f5a5e49fc0b1e4c6cec4628a46f4a4307550b1392673bbf7303f5"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@17"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@17"].opt_prefix

    system "gradle", "shadowJar", "--no-daemon"
    libexec.install "core/build/libs/ktfmt-#{version}-with-dependencies.jar"
    bin.write_jar_script libexec/"ktfmt-#{version}-with-dependencies.jar", "ktfmt", java_version: "17"
  end

  test do
    test_file = testpath/"Test.kt"
    test_file.write <<~EOS
      fun main() { println("Hello, World!") }
    EOS

    output = shell_output("#{bin}/ktfmt --google-style #{test_file} 2>&1")
    assert_match "Done formatting #{test_file}", output
    assert_equal <<~EOS, test_file.read
      fun main() {
        println("Hello, World!")
      }
    EOS
  end
end
