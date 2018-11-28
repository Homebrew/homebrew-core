class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.0.2/easyengine.phar"
  sha256 "299506c9212b9eccddc1b46ad8079d104d508d805d15e88a4010050bf6ee0d91"

  bottle :unneeded

  depends_on "php"

  def install
    bin.install "easyengine.phar" => "ee"
  end

  test do
    system bin/"ee config set locale hi_IN"
    output = shell_output("#{bin}/ee config get locale")
    assert_match "hi_IN", output

    output = shell_output("#{bin}/ee cli version")
    assert_match "EE #{version}", output

    output = shell_output("#{bin}/ee cli info")
    assert_match "Darwin", output
  end
end
