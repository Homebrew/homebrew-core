class Ktfmt < Formula
  desc "Kotlin code formatter"
  homepage "https://facebook.github.io/ktfmt/"
  url "https://github.com/facebook/ktfmt/archive/refs/tags/v0.62.tar.gz"
  sha256 "266c4d774be0f61de17687a49b3acf454d5674dd30caace947c086ec2e00cd42"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a78b1d6dd17daf32f24b39c56462fd9b64fe78e110ee03f5cce9d7e720eaf1b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a78b1d6dd17daf32f24b39c56462fd9b64fe78e110ee03f5cce9d7e720eaf1b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a78b1d6dd17daf32f24b39c56462fd9b64fe78e110ee03f5cce9d7e720eaf1b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a78b1d6dd17daf32f24b39c56462fd9b64fe78e110ee03f5cce9d7e720eaf1b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8730ebfede680e8298d21438c5bad4cf3a088d088b3e8adaf1275fec54a18a3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8730ebfede680e8298d21438c5bad4cf3a088d088b3e8adaf1275fec54a18a3a"
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
