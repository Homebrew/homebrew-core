class MpsYoutube < Formula
  include Language::Python::Virtualenv

  desc "Terminal based YouTube player and downloader"
  homepage "https://github.com/mps-youtube/mps-youtube"
  url "https://github.com/mps-youtube/mps-youtube/archive/v0.2.8.tar.gz"
  sha256 "d5f2c4bc1f57f0566242c4a0a721a5ceaa6d6d407f9d6dd29009a714a0abec74"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f6c2d36688fe64252c8e8c5e7f61b44932311fb49e656455ba0548f730f454f" => :high_sierra
    sha256 "b6e203e6b93d8e4b22d6dfd732a2fdcd3ed0e97c71ca655c54d80c6df1f7cbf9" => :sierra
    sha256 "d7eb2117bda8da380d1d37b72a90d4b2ab81251666bf5f8f2d6dd1f1cfad1d9c" => :el_capitan
    sha256 "026970283c1b6df0951f7ed4155c6719acb014948f02d963a7c9866d911c4292" => :yosemite
  end

  depends_on "python3"
  depends_on "mpv" => :recommended
  depends_on "mplayer" => :optional

  resource "pafy" do
    url "https://files.pythonhosted.org/packages/41/cb/ec840c79942fb0788982963b61a361ecd10e4e58ad3dcaef4f0e809ce2fe/pafy-0.5.4.tar.gz"
    sha256 "e842dc589a339a870b5869cc3802f2e95824edf347f65128223cd5ebdff21024"
  end

  resource "youtube_dl" do
    url "https://files.pythonhosted.org/packages/bb/6c/d7af4a0008fee9c9eccd2dc7d4b6dba008f2b31c19c7003f5af98560188e/youtube_dl-2018.2.11.tar.gz"
    sha256 "80da352d7da4cff7e591a8ab70262fceceaf561b86ec72c0dc86891b31e07090"
  end

  def install
    venv = virtualenv_create(libexec, "python3")

    ["youtube_dl", "pafy"].each do |r|
      venv.pip_install resource(r)
    end

    venv.pip_install_and_link buildpath
  end

  test do
    Open3.popen3("#{bin}/mpsyt", "/september,", "da 1,", "q") do |_, _, stderr|
      assert_empty stderr.read, "Some warnings were raised"
    end
  end
end
