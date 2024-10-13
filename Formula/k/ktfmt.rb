class Ktfmt < Formula
  desc "Kotlin code formatter"
  homepage "https://facebook.github.io/ktfmt/"
  url "https://github.com/facebook/ktfmt/archive/refs/tags/v0.52.tar.gz"
  sha256 "dc4e97265004e399ea14f49bb82944de88c29d1e8d105ed68caef453e0d8c6e0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "96edc276190c92a8d41329b1f227bcab7cc332fe265bb958b58dfe4c45153567"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7cb3c4429048ca0e1ed17659bc7aefd91d9ffca998a865df7d055cdfca9f390b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a6c790dd70506352735b5c57f462a5dbb2110d98a4fdfb18c46cfd93b5112b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7e0fd43e94ad260584746f0a085373582471a27db2724eff7cf7fa1d9713753"
    sha256 cellar: :any_skip_relocation, sonoma:         "5190b5fb757806cad7a99ad542f0208994e75dd83b95c09a63d12ab4ad69f777"
    sha256 cellar: :any_skip_relocation, ventura:        "7f04cab89f4c5132d1c2bf1a5eeb221d9b92c7e698521d09e4a69c5edfb5dd49"
    sha256 cellar: :any_skip_relocation, monterey:       "e00c651910ab4555349263ac7def9060c78e698cbaeafa6b6e49cfc12341b287"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bc616902973172d2888714b6aac280e042cda25b525c08452ffdb08e0daee88"
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
