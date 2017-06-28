class Crowdin < Formula
  desc "Command-line tool that allows to manage your resources with crowdin.com"
  homepage "https://support.crowdin.com/cli-tool/"
  url "https://crowdin.com/downloads/crowdin-cli-2.0.16.zip"
  sha256 "0545c969e22bcbb55a76d39db1650544b9d1912be04226cac0a18fd049b1a238"

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
