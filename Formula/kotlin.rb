class Kotlin < Formula
  desc "Statically typed programming language for the JVM"
  homepage "https://kotlinlang.org/"
  url "https://github.com/JetBrains/kotlin/releases/download/v1.6.20/kotlin-compiler-1.6.20.zip"
  sha256 "daf17db1c194f4205f3af67129367a69b388f819177963dc53a7b4b2c4d8ce22"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6884120c6c0cbd01145f029da712a6ef828eb1462edb3a4c280aa85be3546815"
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
