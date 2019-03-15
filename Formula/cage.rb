class Cage < Formula
  desc "Develop complex, multi‑container Docker applications locally"
  homepage "https://cage.faraday.io/"
  url "https://github.com/faradayio/cage/releases/download/v0.2.7/cage-v0.2.7-osx.zip"
  sha256 "d438383f997a3c5e31ee8c739f35fc2fdd371a186ef295e945b56475842eebd6"
  head "https://github.com/faradayio/cage.git"

  depends_on "docker-compose"

  def install
    bin.install "cage"
  end

  test do
    system "#{bin}/cage", "-h"
  end
end
