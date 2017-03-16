class Crowdin < Formula
  desc "Command-line tool that allows to manage your resources with crowdin.com"
  homepage "https://support.crowdin.com/cli-tool/"
  url "https://crowdin.com/downloads/crowdin-cli-2.0.11.zip"
  sha256 "027925176948b8973ba1a9fab4f0c097bf49f2df0c23be20d79049bd7af4fbc3"

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
