class Ktfmt < Formula
  desc "Kotlin code formatter"
  homepage "https://facebook.github.io/ktfmt/"
  url "https://github.com/facebook/ktfmt/archive/refs/tags/v0.56.tar.gz"
  sha256 "8bb880439fe8fb721fbcb16eabbd5f663b6998430d41ac45653e3f8a1c7541ea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1f30f49423c0967f42fbdf26687536b2d03bc719f01a046422e3093ef851c54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d26a9893debaa6aad0617dd8441e06255b512f26050435f1f86b5415450a882"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "472ef6776f1e18d7b682e6a20d749de3985b3a6d4b5bcee1a7b5cbf2a05e4b55"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe62bf59abb2f6d08852b9f0f9526b71b6fa32b195d7f66c419a5aeea2c8e255"
    sha256 cellar: :any_skip_relocation, ventura:       "c5477affdade026f1831b803a7d943e6347d2fb26cfc48d7d3caca30caca6b80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98836c7bf49943d3876f3ec1af3f5dcd86df70ee32a8d1820d7a7141acf36c51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe2fe77d5e737b3e787b1f86e095e5021d8e7410661bd1dd41f7c9a78dcb0b04"
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
