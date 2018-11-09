class MpsYoutube < Formula
  include Language::Python::Virtualenv

  desc "Terminal based YouTube player and downloader"
  homepage "https://github.com/mps-youtube/mps-youtube"
  url "https://github.com/mps-youtube/mps-youtube/archive/v0.2.8.tar.gz"
  sha256 "d5f2c4bc1f57f0566242c4a0a721a5ceaa6d6d407f9d6dd29009a714a0abec74"
  revision 5

  bottle do
    cellar :any_skip_relocation
    sha256 "0ea34a095f7f53773519e9a36a198ddc71eabb60b87537d126d02ff084646055" => :mojave
    sha256 "e8bda076e052abeae08101720c9117c24baa4a5f561e544ef870ba97c76b98e4" => :high_sierra
    sha256 "fec849d308e04483377b412ed2ea2b6061420cbfb266947f57226e607368545f" => :sierra
    sha256 "9761dff9eb00b7d03ae4e45eb2c1285e3f9f7e139bed5f98bce1523bffe4039d" => :el_capitan
  end

  depends_on "mpv"
  depends_on "python"

  resource "pafy" do
    url "https://files.pythonhosted.org/packages/41/cb/ec840c79942fb0788982963b61a361ecd10e4e58ad3dcaef4f0e809ce2fe/pafy-0.5.4.tar.gz"
    sha256 "e842dc589a339a870b5869cc3802f2e95824edf347f65128223cd5ebdff21024"
  end

  resource "youtube_dl" do
    url "https://files.pythonhosted.org/packages/6a/e0/68e3701ca58ea54aab4abb018ab9fe76807598d45d46a787a3d3c986ec1c/youtube_dl-2018.11.7.tar.gz"
    sha256 "f9b4a65e544b4a2b958ef693cd4b71ab5a5709ab1c7a9fc47c1a967dcca46f4a"
  end

  def install
    venv = virtualenv_create(libexec, "python3")

    ["youtube_dl", "pafy"].each do |r|
      venv.pip_install resource(r)
    end

    venv.pip_install_and_link buildpath
  end

  test do
    Open3.popen3("#{bin}/mpsyt", "/Drop4Drop x Ed Sheeran,", "da 1,", "q") do |_, _, stderr|
      assert_empty stderr.read, "Some warnings were raised"
    end
  end
end
