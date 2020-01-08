class Detekt < Formula
  desc "Static code analysis for Kotlin"
  homepage "https://github.com/arturbosch/detekt"
  url "https://jcenter.bintray.com/io/gitlab/arturbosch/detekt/detekt-cli/1.3.0/detekt-cli-1.3.0-all.jar"
  sha256 "610b0211b909d8e79c1b623119e1d94cb833a8e98b32e5a0e991fa2d214992f6"

  bottle :unneeded

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
