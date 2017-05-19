class MpsYoutube < Formula
  include Language::Python::Virtualenv

  desc "Terminal based YouTube player and downloader"
  homepage "https://github.com/mps-youtube/mps-youtube"
  url "https://github.com/mps-youtube/mps-youtube/archive/v0.2.7.1.tar.gz"
  sha256 "917958ab02f8dace9c84974f510bd8838f905814c1a05a91fb1a38d37d19f0e8"
  revision 4

  bottle do
    cellar :any_skip_relocation
    sha256 "6a0bce23c1aba661233997b6d59e3ac3ee9b790b428a84e01ec759d3e0380302" => :sierra
    sha256 "1793393451f9e24e1fa33d8059529073d6fd79cc70db197052794084ba0e4e58" => :el_capitan
    sha256 "b08913a3417e99db5c27e4173a20a2a98aecf98f964ac814bd491286f37d053c" => :yosemite
  end

  depends_on "python3"
  depends_on "mpv" => :recommended
  depends_on "mplayer" => :optional

  resource "pafy" do
    url "https://files.pythonhosted.org/packages/23/74/0e32a671b445107f34fa785ea2ac3658b0e80aef5446538a6181eba7c2e7/pafy-0.5.3.1.tar.gz"
    sha256 "35e64ff495b5d62f31f65a31ac0ca6dc1ab39e1dbde4d07b1e04845a52eceda8"
  end

  resource "youtube_dl" do
    url "https://files.pythonhosted.org/packages/38/e3/4e3bbc6cdc7a51030c5e3a130c056f6e5fd78f12793f7797f0ccf092b2e3/youtube_dl-2017.5.18.1.tar.gz"
    sha256 "b4876a526191bd7264fcee9cb08d9de921dbfe823852cc9c343e5fb031ffad08"
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
