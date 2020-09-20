class Languagetool < Formula
  desc "Style and grammar checker"
  homepage "https://www.languagetool.org/"
  url "https://languagetool.org/download/LanguageTool-5.0.1.oxt"
  sha256 "9485e964a0686a19a2b9457576531c459a15373c2db9c9078e08289d1a9d47d2"

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
