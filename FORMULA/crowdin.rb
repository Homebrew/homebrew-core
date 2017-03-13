class Crowdin < Formula
  desc "Crowdin-CLI is a command-line tool that allows to manage your resources"
  homepage "https://support.crowdin.com/cli-tool/"
  url "https://crowdin.com/downloads/crowdin-cli-2.0.11.zip"
  sha256 "027925176948b8973ba1a9fab4f0c097bf49f2df0c23be20d79049bd7af4fbc3"

  def install
    bin.install "crowdin-cli.jar"
    system "alias", "crowdin=\"'java -jar #{bin}/crowdin-cli.jar'\" >> ~/.bashrc"
    system "alias", "crowdin=\"'java -jar #{bin}/crowdin-cli.jar'\" >> ~/.bash_profile"
  end

  test do
    system "java", "-jar", "#{bin}/crowdin-cli.jar"
  end
end
