class Languagetool < Formula
  desc "Style and grammar checker"
  homepage "https://www.languagetool.org/"
  url "https://languagetool.org/download/LanguageTool-5.1.zip"
  sha256 "c91ff43d54c863a9389a81c5fa1a6723041b982435f220e9c2c4db843b66d1b6"

  livecheck do
    url "https://github.com/languagetool-org/languagetool.git"
  end

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
