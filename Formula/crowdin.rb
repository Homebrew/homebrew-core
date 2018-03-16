class Crowdin < Formula
  desc "Command-line tool that allows to manage your resources with crowdin.com"
  homepage "https://support.crowdin.com/cli-tool/"
  url "https://downloads.crowdin.com/cli/v2/crowdin-cli-2.0.22.zip"
  sha256 "f3967960a4063bf69bf0f5acedceb2417134b1a3e75d304838f9d9fcc90660a5"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    libexec.install "crowdin-cli.jar"
    bin.write_jar_script libexec/"crowdin-cli.jar", "crowdin"
  end

  test do
    system bin/"crowdin"
  end
end
