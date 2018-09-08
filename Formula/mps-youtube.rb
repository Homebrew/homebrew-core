class MpsYoutube < Formula
  include Language::Python::Virtualenv

  desc "Terminal based YouTube player and downloader"
  homepage "https://github.com/mps-youtube/mps-youtube"
  url "https://github.com/mps-youtube/mps-youtube/archive/v0.2.8.tar.gz"
  sha256 "d5f2c4bc1f57f0566242c4a0a721a5ceaa6d6d407f9d6dd29009a714a0abec74"
  revision 3

  bottle do
    cellar :any_skip_relocation
    sha256 "2536131062057af7d686bf00bdf51eed1dede249212f3cfc9da4a7e3a60b0bcd" => :mojave
    sha256 "49813e6178f80f596316552e88c0412bff5abc3f03634112a7a870b0b12d9ff7" => :high_sierra
    sha256 "a8395b866a3b42e7ebea186224f962cdbde3ff1058514bcce86fa9cfdaf24a6a" => :sierra
    sha256 "295450a0d67859bb15e901c2717dbaa5edfbe76d60672f2ff662173312a63415" => :el_capitan
  end

  depends_on "python"
  depends_on "mpv" => :recommended
  depends_on "mplayer" => :optional

  resource "pafy" do
    url "https://files.pythonhosted.org/packages/41/cb/ec840c79942fb0788982963b61a361ecd10e4e58ad3dcaef4f0e809ce2fe/pafy-0.5.4.tar.gz"
    sha256 "e842dc589a339a870b5869cc3802f2e95824edf347f65128223cd5ebdff21024"
  end

  resource "youtube_dl" do
	url "https://github.com/rg3/youtube-dl/releases/download/2018.09.08/youtube-dl-2018.09.08.tar.gz"
  	sha256 "05381dd1651398a664ce5c22eff9172c170b4c9ef53b52ed58b9b58695238c6f"
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
