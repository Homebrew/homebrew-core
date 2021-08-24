class Kotlin < Formula
  desc "Statically typed programming language for the JVM"
  homepage "https://kotlinlang.org/"
  url "https://github.com/JetBrains/kotlin/releases/download/v1.5.30/kotlin-compiler-1.5.30.zip"
  sha256 "25eebdb9bb2e165e4ba8efbf8ff943c45d4fc39dbffc2c1caa059e8dd813675f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "944c2f9b97852160829721ccdf47c510b416454e71f6da0035d9b3d1eac6c50a"
  end

  depends_on "openjdk"

  def install
    libexec.install "bin", "build.txt", "lib"
    rm Dir["#{libexec}/bin/*.bat"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
    prefix.install "license"
  end

  test do
    (testpath/"test.kt").write <<~EOS
      fun main(args: Array<String>) {
        println("Hello World!")
      }
    EOS
    system "#{bin}/kotlinc", "test.kt", "-include-runtime", "-d", "test.jar"
    system "#{bin}/kotlinc-js", "test.kt", "-output", "test.js"
    system "#{bin}/kotlinc-jvm", "test.kt", "-include-runtime", "-d", "test.jar"
  end
end
