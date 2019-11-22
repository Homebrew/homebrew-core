class MpsYoutube < Formula
  include Language::Python::Virtualenv

  desc "Terminal based YouTube player and downloader"
  homepage "https://github.com/mps-youtube/mps-youtube"
  url "https://github.com/mps-youtube/mps-youtube/archive/v0.2.8.tar.gz"
  sha256 "d5f2c4bc1f57f0566242c4a0a721a5ceaa6d6d407f9d6dd29009a714a0abec74"
  revision 8

  bottle do
    cellar :any_skip_relocation
    rebuild 4
    sha256 "94b1a1ee53f3808545b8cfe1bfdd60a0347c869c9637b097f6897eff71e06406" => :catalina
    sha256 "567d91b7531d4cd44529b15f35aafecc0deefed6ff4251a32a51cd0b9e2f060a" => :mojave
    sha256 "54561e5998860437fd853041c19db9f6bc40ed6365cd2533593ce9d8f9597acc" => :high_sierra
    sha256 "029ff729d697a093a9cf405ec5a68a38c0cc438d76c43f1e44d0ec7cd79a83d8" => :sierra
  end

  depends_on "mplayer"
  depends_on "python"

  resource "pafy" do
    url "https://files.pythonhosted.org/packages/41/cb/ec840c79942fb0788982963b61a361ecd10e4e58ad3dcaef4f0e809ce2fe/pafy-0.5.4.tar.gz"
    sha256 "e842dc589a339a870b5869cc3802f2e95824edf347f65128223cd5ebdff21024"
  end

  resource "youtube_dl" do
    url "https://files.pythonhosted.org/packages/34/8b/a9d28a385c56f1945753614705ba2018355100efab7d4161e60b9d8dc801/youtube_dl-2019.9.12.1.tar.gz"
    sha256 "d61dd64e81a4cc026726b25981faf8ef8453363598483d51f7dc6f6d5580a78f"
  end

  def install
    venv = virtualenv_create(libexec, "python3")

    %w[youtube_dl pafy].each do |r|
      venv.pip_install resource(r)
    end

    venv.pip_install_and_link buildpath
  end

  def caveats
    <<~EOS
      Install the optional mpv app with Homebrew Cask:
        brew cask install mpv
    EOS
  end

  test do
    Open3.popen3("#{bin}/mpsyt", "/Drop4Drop x Ed Sheeran,", "da 1,", "q") do |_, _, stderr|
      assert_empty stderr.read, "Some warnings were raised"
    end
  end
end
