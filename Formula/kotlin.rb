class Kotlin < Formula
  desc "Statically typed programming language for the JVM"
  homepage "https://kotlinlang.org/"
  url "https://github.com/JetBrains/kotlin/releases/download/v1.4.0/kotlin-compiler-1.4.0.zip"
  sha256 "590391d13b3c65ba52cba470f56efd5b14e2b1f5b9459f63aa12eb38ef52f161"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/JetBrains/kotlin/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle :unneeded

  def install
    libexec.install "bin", "build.txt", "lib"
    rm Dir["#{libexec}/bin/*.bat"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
