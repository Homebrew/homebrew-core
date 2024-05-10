class Ktfmt < Formula
  desc "Kotlin code formatter"
  homepage "https://facebook.github.io/ktfmt/"
  url "https://github.com/facebook/ktfmt/archive/refs/tags/v0.49.tar.gz"
  sha256 "516c1c76ff1a9144daebbbd1feccdadbddd93ff2de051514e0dcd4f8545ab71c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "172b73b5c59b1cbf806c3763c24319fac798fb6f7dd65ab8da6e125dbd8f7d2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39a8f391fb3f4ee3bcbad716684ba1db2eaff6cf02fa9d1fd8c5ec98f3679d7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c527a4b3f64ec86a41b76d73db1d0a01acb0138721cc4e9b37372e62a4e4395"
    sha256 cellar: :any_skip_relocation, sonoma:         "1b2d662838e326e07bd6b44084b796c90645ee909be3348c78502c4bb32d7d2e"
    sha256 cellar: :any_skip_relocation, ventura:        "c5bb011e0745fa849865f0f8c0207ca86a8bf52b355942950c8a6753d8910c88"
    sha256 cellar: :any_skip_relocation, monterey:       "840c7036a60ac6cd9a7d45b79c83c7dd60de983455a11365e816ac7ef1d5d701"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "258101f986f08262414148be288cc96eb021c8cc47cdfcaca7eb8f128eca9d54"
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
