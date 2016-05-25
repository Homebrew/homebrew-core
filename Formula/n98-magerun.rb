class N98Magerun < Formula
  desc "The swiss army knife for Magento developers, sysadmins and devops."
  homepage "http://magerun.net/"
  url "https://files.magerun.net/n98-magerun.phar"
  version "1.0.0"
  sha256 "199dd0d416260c68e691580ffd3f7a448d60f616529aadadcfee584992d6253e"

  def install
    bin.install "n98-magerun.phar" => "n98-magerun"
  end

  test do
    system "#{bin}/n98-magerun", "--version"
  end
end
