class Languagetool < Formula
  desc "Style and grammar checker"
  homepage "https://www.languagetool.org/"
  url "https://languagetool.org/download/LanguageTool-4.8.zip"
  sha256 "b4775e88fd90d6389f86023600c4c0e16a9cc00cfe8f093bf1f0c2bbf2a1904d"
  revision 1

  bottle :unneeded
  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    (bin/"languagetool").write <<~EOS
      #!/bin/bash
      exec "#{Formula["openjdk"].opt_bin}/java" -jar "#{libexec}/languagetool-commandline.jar" "$@"
    EOS
    (bin/"languagetool-server").write <<~EOS
      #!/bin/bash
      exec "#{Formula["openjdk"].opt_bin}/java" -cp "#{libexec}/languagetool-server.jar" org.languagetool.server.HTTPServer "$@"
    EOS
    (bin/"languagetool-gui").write <<~EOS
      #!/bin/bash
      exec "#{Formula["openjdk"].opt_bin}/java" -jar "#{libexec}/languagetool.jar" "$@"
    EOS
  end

  test do
    pipe_output("#{bin}/languagetool -l en-US -", "This is a test.")
  end
end
