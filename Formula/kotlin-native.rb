class KotlinNative < Formula
  desc "Technology for compiling Kotlin code to native binaries"
  homepage "https://kotlinlang.org/docs/reference/native-overview.html"
  url "https://github.com/JetBrains/kotlin/releases/download/v1.3.0/kotlin-native-macos-1.3.0.tar.gz"
  sha256 "0621a7c32db37b695b95f75c9085f2d20ba46c74934973cc47fbf09b7e265401"

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
