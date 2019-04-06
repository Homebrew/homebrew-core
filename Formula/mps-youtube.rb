class MpsYoutube < Formula
  include Language::Python::Virtualenv

  desc "Terminal based YouTube player and downloader"
  homepage "https://github.com/mps-youtube/mps-youtube"
  url "https://github.com/mps-youtube/mps-youtube/archive/v0.2.8.tar.gz"
  sha256 "d5f2c4bc1f57f0566242c4a0a721a5ceaa6d6d407f9d6dd29009a714a0abec74"
  revision 7

  bottle do
    cellar :any_skip_relocation
    sha256 "ac649a7aea7518f1155ad9c2675c1735e617788b10639fdc4b96fc14b75d95cf" => :mojave
    sha256 "a6aeaff1f55ede1a00e2b21ca5bab1c21002cfe492971c81bddeb4bc8dadde91" => :high_sierra
    sha256 "2ebd7005338eff1fd9a92e58f707d9ab9998f155aee9d42e37dc276e2b77c0ab" => :sierra
  end

  depends_on "mpv"
  depends_on "python"

  resource "pafy" do
    url "https://files.pythonhosted.org/packages/41/cb/ec840c79942fb0788982963b61a361ecd10e4e58ad3dcaef4f0e809ce2fe/pafy-0.5.4.tar.gz"
    sha256 "e842dc589a339a870b5869cc3802f2e95824edf347f65128223cd5ebdff21024"
  end

  resource "youtube_dl" do
    url "https://files.pythonhosted.org/packages/60/00/234371dc09f7345743cb37dabedabe6939743c85c8e745c32d2849d52277/youtube_dl-2019.4.1.tar.gz"
    sha256 "b7efff0b7960111370a09b59fe2800341ec51d03f591d0dc29b026d28b801dff"
  end

  def install
    venv = virtualenv_create(libexec, "python3")

    %w[youtube_dl pafy].each do |r|
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
