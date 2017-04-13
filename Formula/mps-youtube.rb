class MpsYoutube < Formula
  include Language::Python::Virtualenv

  desc "Terminal based YouTube player and downloader"
  homepage "https://github.com/mps-youtube/mps-youtube"
  url "https://github.com/mps-youtube/mps-youtube/archive/v0.2.7.1.tar.gz"
  sha256 "917958ab02f8dace9c84974f510bd8838f905814c1a05a91fb1a38d37d19f0e8"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "4f62012fcfd6741ddfc611dc8f9c708e05c58c53124c31d1b33f5f05e5c3a379" => :sierra
    sha256 "19f703e559355d7ce49fc19a21475216ce0bcd87d4076e65ed2235af5ace13d9" => :el_capitan
    sha256 "c1a6f0b5da9da27ce987f3a48fb810c62110354f7a978785974f4d267ba4936e" => :yosemite
  end

  depends_on "python3"
  depends_on "mpv" => :recommended
  depends_on "mplayer" => :optional

  resource "pafy" do
    url "https://files.pythonhosted.org/packages/23/74/0e32a671b445107f34fa785ea2ac3658b0e80aef5446538a6181eba7c2e7/pafy-0.5.3.1.tar.gz"
    sha256 "35e64ff495b5d62f31f65a31ac0ca6dc1ab39e1dbde4d07b1e04845a52eceda8"
  end

  resource "youtube_dl" do
    url "https://files.pythonhosted.org/packages/19/21/0ff2fe2aabfea1a6ba2fd13275df2d137a703c98f1485ef5fa94cd9f82fa/youtube_dl-2017.4.11.tar.gz"
    sha256 "940d8541f9b1b6a1a099c60ec0e48cb552fc1f12c7ce69b39495b42c16ee7845"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    Open3.popen3("#{bin}/mpsyt", "/september,", "da 1,", "q") do |_, _, stderr|
      assert_empty stderr.read, "Some warnings were raised"
    end
  end
end
