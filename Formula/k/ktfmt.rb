class Ktfmt < Formula
  desc "Kotlin code formatter"
  homepage "https://facebook.github.io/ktfmt/"
  url "https://github.com/facebook/ktfmt/archive/refs/tags/v0.54.tar.gz"
  sha256 "604e7bd519856c3e2a8b44accf6ed9fd4c4b86ae7f7dd0a9b598d483dce18206"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75c4e2473e6cf2ae1216da62f998bd965dc703b0fab27aacc51631ca9d147195"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d59ea16d67f657484e8a242e031a194331c82b7d634fc076088a91aaaa2ec105"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "520a806c81cf73b9114cde115eed478a12fe16408ce479025e59145ed9fb7b3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "70c27859a5649fbdb01d3c6ba3353458a4fc2cfd586a26bd41d95d3871586650"
    sha256 cellar: :any_skip_relocation, ventura:       "96f291159d94270a217eafb0ae97e47c78ab52d333db38b3abdf5698b68ce92f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af8fd3794aba5fceb429d7d23aefb92c594ebcec2f5529cee7ad3fc69a568b04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24e562f6d2d1c82a7cbd980cbd70506a60f7d873b23e03e120ac861aa8fac226"
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
