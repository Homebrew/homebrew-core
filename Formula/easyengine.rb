class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.0.11/easyengine.phar"
  sha256 "6c486ab6d14ac8ea2651027a2c7c8615309fdf57f18f8051dd4fc14e8042d770"

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
