class N98Magerun2 < Formula
  desc "Swiss army knife for Magento 2 developers, sysadmins and devops."
  homepage "http://magerun.net/"
  url "https://files.magerun.net/n98-magerun2-1.1.12.phar"
  sha256 "2382b99c6f7b9cd91ef5482d8321b1c6c0910643ece5a63f712d2cb0be9f50c9"

  bottle :unneeded

  def install
    bin.install "n98-magerun2-#{version}.phar" => "n98-magerun2"
  end

  test do
    system "#{bin}/n98-magerun2", "list"
  end
end
