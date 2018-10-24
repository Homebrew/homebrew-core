class Languagetool < Formula
  desc "Style and grammar checker"
  homepage "https://www.languagetool.org/"
  url "https://languagetool.org/download/LanguageTool-4.3.zip"
  sha256 "65a9f222329390497c3db7944ad5f3a7ee2d54957a956ccf15b4a62a1a561aa4"

  bottle :unneeded
  depends_on :java => "1.8+"

  def server_script(server_jar); <<~EOS
    #!/bin/bash
    exec java -cp #{server_jar} org.languagetool.server.HTTPServer "$@"
  EOS
  end

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"languagetool-commandline.jar", "languagetool"
    (bin+"languagetool-server").write server_script(libexec/"languagetool-server.jar")
    bin.write_jar_script libexec/"languagetool.jar", "languagetool-gui"
  end

  test do
    pipe_output("#{bin}/languagetool -l en-US -", "This is a test.")
  end
end
