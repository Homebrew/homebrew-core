class DrushLauncher < Formula
  desc "Small wrapper around Drush for your global $PATH"
  homepage "https://github.com/drush-ops/drush-launcher"
  url "https://github.com/drush-ops/drush-launcher/releases/download/0.9.1/drush.phar"
  sha256 "52b5e22031789e087e4f79ac49c74d94c0379ad6859f3ec14671ce1647a3b7a6"
  license "GPL-2.0-or-later"

  uses_from_macos "php"
  depends_on "php" => :test

  def install
    bin.install "drush.phar" => "drush"
  end

  test do
    system "#{bin}/drush", "--drush-launcher-version"
  end
end
