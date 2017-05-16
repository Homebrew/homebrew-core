class Crowdin < Formula
  desc "Command-line tool that allows to manage your resources with crowdin.com"
  homepage "https://support.crowdin.com/cli-tool/"
  url "https://crowdin.com/downloads/crowdin-cli-2.0.12.zip"
  sha256 "6fbfba28ae22ba17f1d8aa262c849ef2c3735ae327b10f22445d5739ee138291"
  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    bin.install "crowdin-cli.jar"
    crowdin = bin/"crowdin"
    crowdin.write <<-EOS.undent
      #!/bin/bash
      java -jar "#{bin}/crowdin-cli.jar" "$@"
    EOS
    chmod 0755, crowdin
  end

  test do
    system "java", "-jar", "#{bin}/crowdin-cli.jar"
  end
end
