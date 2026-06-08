class Ktfmt < Formula
  desc "Kotlin code formatter"
  homepage "https://facebook.github.io/ktfmt/"
  url "https://github.com/facebook/ktfmt/archive/refs/tags/v0.63.tar.gz"
  sha256 "1f284160c50b3309d2a61ce22f9bd60aa7c8fc86d16aae0bac55ac132b242460"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "106bb88438645dd8c6637d63045e8939d234cef082b53bd0dd862f4d1fdd6e31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "106bb88438645dd8c6637d63045e8939d234cef082b53bd0dd862f4d1fdd6e31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "106bb88438645dd8c6637d63045e8939d234cef082b53bd0dd862f4d1fdd6e31"
    sha256 cellar: :any_skip_relocation, sonoma:        "106bb88438645dd8c6637d63045e8939d234cef082b53bd0dd862f4d1fdd6e31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac48dd69361bd524166f0197bb1d2a30fa954c113c859f8ea329fe84252f830b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac48dd69361bd524166f0197bb1d2a30fa954c113c859f8ea329fe84252f830b"
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
