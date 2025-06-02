class Ktfmt < Formula
  desc "Kotlin code formatter"
  homepage "https://facebook.github.io/ktfmt/"
  url "https://github.com/facebook/ktfmt/archive/refs/tags/v0.55.tar.gz"
  sha256 "edcb30aea63af6b0665bced302b47ac70a9fdae639c626827bc85fddbc69ae39"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8725b050ed14f3f94dc7d27da9459e373f432561acce702bc9150f1d230ea13a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f204926b6dfdc82576df2bc1c3bc07e8cb11efe09273d3f1222209f2e4aa4d08"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c0652f3b55cf5f237cca800bcdc3dcfbc12dec4d3deaa68e585b817f935db82"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7eec80d393cf1ea4ae4c34f6cef8c9acb178ebf00c8edc3e1504a434db7d5f0"
    sha256 cellar: :any_skip_relocation, ventura:       "7b0c7e9412610d4c0feaa50dcd314e7e4c95831dc0053909a8e3a2caf39f66ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f538037d80577c10b67d3ec63bbbae42eb4e3070d397564bd298b49d6fa4bbc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ac466bd2e1869e4e78e57826bc919d30378b33129a02fd1b4f7ec2d36d46287"
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
