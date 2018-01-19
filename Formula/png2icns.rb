class Png2icns < Formula
  desc "Easily convert a png image to an icns"
  homepage "https://github.com/bitboss-ca/png2icns"
  url "https://github.com/bitboss-ca/png2icns/archive/v0.1.tar.gz"
  sha256 "adb9726483770dac9f9945e791223e1977aeb008481ea5dd80cdaaedd1bb3714"

  bottle :unneeded

  def install
    bin.install "png2icns.sh" => "png2icns"
  end

  test do
    system "#{bin}/png2icns"
  end
end
