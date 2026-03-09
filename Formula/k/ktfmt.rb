class Ktfmt < Formula
  desc "Kotlin code formatter"
  homepage "https://facebook.github.io/ktfmt/"
  url "https://github.com/facebook/ktfmt/archive/refs/tags/v0.61.tar.gz"
  sha256 "4270802d15b293c7244a33303e05511e9a5e464b34b2565c7ec46995ff74c203"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3bd319b2f2e10b5ec80a55334cef431729db2654c5970b26caeff26a2420f5cd"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@17"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@17"].opt_prefix

    system "gradle", "shadowJar", "--no-daemon"
    libexec.install "core/build/libs/ktfmt-#{version}-with-dependencies.jar"
    # TODO: add a flag for Java 23 or above, see https://github.com/facebook/ktfmt/issues/533.
    java_opts = "$(\"${JAVA_HOME}/bin/java\" -version 2>&1 | " \
                "grep -q -E -e 'version \"(2[3-9]|[3-9][0-9])' && " \
                "echo '--sun-misc-unsafe-memory-access=allow')"
    bin.write_jar_script libexec/"ktfmt-#{version}-with-dependencies.jar", "ktfmt", java_opts: java_opts, java_version: "17"
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
