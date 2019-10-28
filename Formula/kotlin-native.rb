class KotlinNative < Formula
  desc "Kotlin/Native infrastructure"
  homepage "https://github.com/JetBrains/kotlin-native"
  url "https://github.com/JetBrains/kotlin-native/archive/v1.3.50.tar.gz"
  sha256 "2c20e3f79f223beba2c37bca761e8507e946ed4e4c5893ef5586dc5d7844357c"

  depends_on "gradle" => :build
  depends_on "kotlin"

  def install
    ENV.deparallelize
    opoo "Building Kotlin/Native can take a while. It may look like things are hanging, but give it time!"
    system "./gradlew", "dependencies:update"
    system "./gradlew", "bundle"
    system "./gradlew", "dist", "distPlatformLibs"
    libexec.install Dir["dist/*"]
    bin.install_symlink libexec/"bin/konanc"
    bin.install_symlink libexec/"bin/konan-lldb"
    bin.install_symlink libexec/"bin/klib"
    bin.install_symlink libexec/"bin/cinterop"
    bin.install_symlink libexec/"bin/jsinterop"
    bin.install_symlink libexec/"bin/kotlinc-native"
    bin.install_symlink libexec/"bin/run_konan"
    prefix.install "README.md"
  end

  test do
    (testpath/"test.kt").write <<~EOS
      fun main(args: Array<String>) {
        println("Hello world!")
      }
    EOS
    system "#{bin}/kotlinc-native", "test.kt", "-o", "test.kexe"
  end
end
