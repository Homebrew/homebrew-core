class Ktfmt < Formula
  desc "Kotlin code formatter"
  homepage "https://facebook.github.io/ktfmt/"
  url "https://github.com/facebook/ktfmt/archive/refs/tags/v0.50.tar.gz"
  sha256 "4ebc36a33480adc516e804f5ca452b7da17245a0cda44b3d07955706f2d8243f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7cf55730f8800dfe97c4dca73cc3cab0906b32c8cb41a0a5ecffefd4d26567ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0303e8024d2b376ed3c66c58ef20fbdedcd40b140d6dabd08a1ed082352383c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e6564a4aae925e0b859dce8047df4a27adddd0f8384f982556c4813c1e7ceb0"
    sha256 cellar: :any_skip_relocation, sonoma:         "b679a738a9331417e6a6830683b1f91de05bca9623c820ae33529c32504cbd3c"
    sha256 cellar: :any_skip_relocation, ventura:        "47065489574f7b1dec03383a8b986f021e5bad8f6e27c1f99af7fda2076fed9a"
    sha256 cellar: :any_skip_relocation, monterey:       "b4e24035dd38f229f39c9417f0484129b2cd81aed11e368f5f537d71f2b084b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "564b1af8a7c81ed811c2ec1519a598386b27783fefbd255c1f9c61194a3f40c3"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    system "mvn", "clean", "package", "-DskipTests=true", "-Dmaven.javadoc.skip=true"
    libexec.install "core/target/ktfmt-#{version}-jar-with-dependencies.jar"
    bin.write_jar_script libexec/"ktfmt-#{version}-jar-with-dependencies.jar", "ktfmt"
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
