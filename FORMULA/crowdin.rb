class Crowdin < Formula
  desc "Command-line tool that allows to manage your resources with crowdin.com"
  homepage "https://support.crowdin.com/cli-tool/"
  url "https://crowdin.com/downloads/crowdin-cli-2.0.14.zip"
  sha256 "b1518d17f2d6076d487a0583ee42b643c66910bd0995dba6eedfe1e504595337"
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
