class Kotlin < Formula
  desc "Statically typed programming language for the JVM"
  homepage "https://kotlinlang.org/"
  url "https://github.com/JetBrains/kotlin/releases/download/v2.2.21/kotlin-compiler-2.2.21.zip"
  sha256 "a623871f1cd9c938946948b70ef9170879f0758043885bbd30c32f024e511714"
  license "Apache-2.0"

  # Upstream maintains multiple major/minor versions and the "latest" release
  # may be for a lower version, so we have to check multiple releases to
  # identify the highest version.
  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eafc9dd08dd4537a0e3bedeb0b126361cf772fa330425e4c31d9714c8814288b"
  end

  depends_on "openjdk"

  conflicts_with cask: "kotlin-native"

  def install
    libexec.install "bin", "build.txt", "lib"
    rm Dir[libexec/"bin/*.bat"]
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
    prefix.install "license"
  end

  test do
    (testpath/"test.kt").write <<~KOTLIN
      fun main(args: Array<String>) {
        println("Hello World!")
      }
    KOTLIN

    system bin/"kotlinc", "test.kt", "-include-runtime", "-d", "test.jar"
    system bin/"kotlinc-jvm", "test.kt", "-include-runtime", "-d", "test.jar"
  end
end
