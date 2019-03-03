class KotlinNative < Formula
  desc "Technology for compiling Kotlin code to native binaries"
  homepage "https://kotlinlang.org/docs/reference/native-overview.html"
  url "https://github.com/JetBrains/kotlin/releases/download/v1.3.11/kotlin-native-macos-1.3.11.tar.gz"
  sha256 "0813985e9cabf2393cf3396e5eb08a4b4bb21ed14e838a8b9e56b2809e89d284"

  bottle :unneeded

  def install
    libexec.install "bin", "klib", "konan", "tools"
    bin.install_symlink Dir["#{libexec}/bin/*"]
    prefix.install "README.md"
  end

  test do
    (testpath/"test.kt").write <<~EOS
      fun main(args: Array<String>) {
        println("Hello World!")
      }
    EOS
    system "#{bin}/kotlinc-native", "test.kt", "-o", "test.kexe"
  end
end
