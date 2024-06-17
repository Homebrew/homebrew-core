class Kotlin < Formula
  desc "Statically typed programming language for the JVM"
  homepage "https://kotlinlang.org/"
  url "https://github.com/JetBrains/kotlin/releases/download/v2.0.0/kotlin-compiler-2.0.0.zip"
  sha256 "ef578730976154fd2c5968d75af8c2703b3de84a78dffe913f670326e149da3b"
  license "Apache-2.0"

  # This repository has thousands of development tags, so the `GithubLatest`
  # strategy is used to minimize data transfer in this extreme case.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26173866c95207355e2972a8c39c882dedc6c7f579146c0e3adb7af1fc63fe4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d887033efa9ac34d93c58633bf3f2e19ac9b3e6b242e6f381d6dc33a42bcdbce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43479c1e7e4957b375e282542e020237e605c82be87dddef8314a74ea4013421"
    sha256 cellar: :any_skip_relocation, sonoma:         "f1a87e019884b57d775a8d1b5607577ebf484a26220393288406c8d6abfc83f1"
    sha256 cellar: :any_skip_relocation, ventura:        "47d66c769a676f39a7487cc1fe0c13f09bd8397dacfac5381ea6c7c68289953e"
    sha256 cellar: :any_skip_relocation, monterey:       "8f812cf1f452ed950407668fa8d64b74c9e4661fd35bbbcc48bd125055dcedac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb8389d5cb816c81a50ecf4cdee1b87d73bce147bc03d90308b4bd4a81f71592"
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
    system bin/"kotlinc-jvm", "test.kt", "-include-runtime", "-d", "test.jar"
  end
end
