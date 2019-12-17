class Detekt < Formula
  desc "Static code analysis for Kotlin"
  homepage "https://github.com/arturbosch/detekt"
  url "https://jcenter.bintray.com/io/gitlab/arturbosch/detekt/detekt-cli/1.2.1/detekt-cli-1.2.1-all.jar"
  sha256 "40de5df866fa0fd12acebb63af75da50d1f4dd3e5c5576f08a9f330b1ba8beee"

  bottle do
    cellar :any_skip_relocation
    sha256 "e3788d2fa44d85703fac30c55da318c3f772a9c6dc8274c631c69f8b25872f6e" => :catalina
    sha256 "e3788d2fa44d85703fac30c55da318c3f772a9c6dc8274c631c69f8b25872f6e" => :mojave
    sha256 "e3788d2fa44d85703fac30c55da318c3f772a9c6dc8274c631c69f8b25872f6e" => :high_sierra
  end

  depends_on :java => "1.8+"

  def install
    libexec.install "detekt-cli-#{version}-all.jar"
    bin.write_jar_script libexec/"detekt-cli-#{version}-all.jar", "detekt"
  end

  test do
    (testpath/"input.kt").write <<~EOS
      fun main() {

      }
    EOS
    system bin/"detekt", "--input", "input.kt", "--report", "txt:output.txt"
    assert_equal "EmptyFunctionBlock", shell_output("cat output.txt").slice(/\w+/)
  end
end
