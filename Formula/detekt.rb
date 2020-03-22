class Detekt < Formula
  desc "Static code analysis for Kotlin"
  homepage "https://github.com/arturbosch/detekt"
  url "https://jcenter.bintray.com/io/gitlab/arturbosch/detekt/detekt-cli/1.7.0/detekt-cli-1.7.0-all.jar"
  sha256 "1dc555b49996b6e0c54986ade81701c0b3b2308ba5da2998f27d42fdbc441336"

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install "detekt-cli-#{version}-all.jar"
    (bin/"detekt").write <<~EOS
      #!/bin/bash
      exec "#{Formula["openjdk"].opt_bin}/java" -jar "#{libexec}/detekt-cli-#{version}-all.jar" "$@"
    EOS
  end

  test do
    (testpath/"input.kt").write <<~EOS
      fun main() {

      }
    EOS
    (testpath/"detekt.yml").write <<~EOS
      empty-blocks:
        EmptyFunctionBlock:
          active: true
    EOS
    system bin/"detekt", "--input", "input.kt", "--report", "txt:output.txt", "--config", "detekt.yml"
    assert_equal "EmptyFunctionBlock", shell_output("cat output.txt").slice(/\w+/)
  end
end
