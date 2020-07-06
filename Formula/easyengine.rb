class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.1.0/easyengine.phar"
  sha256 "9583a9cad7a6d8b467fedf1ef20d0901f59e690a8741903fba041efc8108ae35"

  bottle :unneeded

  depends_on "dnsmasq"
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
