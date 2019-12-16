class Detekt < Formula
  desc "Static code analysis for Kotlin"
  homepage "https://github.com/arturbosch/detekt"
  url "https://jcenter.bintray.com/io/gitlab/arturbosch/detekt/detekt-cli/1.1.1/detekt-cli-1.1.1-all.jar"
  sha256 "8b17c25cd0e9c507773eae0afff97e89c4a1c502b1b1b91c8d55a62032326b3a"

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
