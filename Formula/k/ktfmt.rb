class Ktfmt < Formula
  desc "Kotlin code formatter"
  homepage "https://facebook.github.io/ktfmt/"
  url "https://github.com/facebook/ktfmt/archive/refs/tags/v0.47.tar.gz"
  sha256 "c8115bdf832e0be74934796e786bf08f580883eaf43a916a8bcc833b957ae7b8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af79dbe2ee4daad1f971a6d3b8f62ad59ad79f930190f7e1b774142d7fcabb75"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9cdb734c27caf80f2cf838ce72967c9bdee7f1bd0e08dd4a4d87d8fbe1b70160"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93c42dedaf8f9d743f98c2426d4aa80075d75e87dd09604c06a92b84c4cb4259"
    sha256 cellar: :any_skip_relocation, sonoma:         "828f4d7efc42e613b71c6fb9a0d5c7ac08ec5afc0b00673372230b746d57b763"
    sha256 cellar: :any_skip_relocation, ventura:        "aca2554f9449555dda4e5e59a9d6349802f92de90855a4b308ea15778e114103"
    sha256 cellar: :any_skip_relocation, monterey:       "a4a55fc65419e987a875e7ce29537d58afdb283140f2dc29fd78ae645f50e33b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "971d59e161cc0c8aa09b55044b90b7a8090c400e6b3d8b58101e41559b57189a"
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
