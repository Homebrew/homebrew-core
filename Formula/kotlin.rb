class Kotlin < Formula
  desc "Statically typed programming language for the JVM"
  homepage "https://kotlinlang.org/"
  url "https://github.com/JetBrains/kotlin/releases/download/v1.6.10/kotlin-compiler-1.6.10.zip"
  sha256 "432267996d0d6b4b17ca8de0f878e44d4a099b7e9f1587a98edc4d27e76c215a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ea3ca618fe8113249de6b9852c28b27e067bdd8f7145d857f17181606ef656e0"
  end

  depends_on "openjdk"

  def install
    libexec.install "bin", "build.txt", "lib"
    rm Dir[libexec/"bin/*.bat"]
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
    prefix.install "license"
  end

  test do
    (testpath/"test.kt").write <<~EOS
      fun main(args: Array<String>) {
        println("Hello World!")
      }
    EOS
    system bin/"kotlinc", "test.kt", "-include-runtime", "-d", "test.jar"
    system bin/"kotlinc-js", "test.kt", "-output", "test.js"
    system bin/"kotlinc-jvm", "test.kt", "-include-runtime", "-d", "test.jar"
  end
end
