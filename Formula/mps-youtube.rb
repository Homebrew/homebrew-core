class MpsYoutube < Formula
  include Language::Python::Virtualenv

  desc "Terminal based YouTube player and downloader"
  homepage "https://github.com/mps-youtube/mps-youtube"
  url "https://github.com/mps-youtube/mps-youtube/archive/v0.2.7.1.tar.gz"
  sha256 "917958ab02f8dace9c84974f510bd8838f905814c1a05a91fb1a38d37d19f0e8"

  depends_on "python3"
  depends_on "mpv" => :recommended
  depends_on "youtube-dl" => :recommended
  depends_on "mplayer" => :optional

  resource "pafy" do
    url "https://pypi.python.org/packages/0d/f1/765c5a2e9264ab98b5515501e794962a56157e1809c96c7445d8c2cef136/pafy-0.5.2.tar.gz"
    sha256 "11e0cb83bd9e636bc4d0d6f7d7ce964f4975c6f0e037fe285ef2acedafcf7bb2"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/mpsyt", "/september,", "da 1,", "q"
  end
end
