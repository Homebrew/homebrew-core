class MpsYoutube < Formula
  include Language::Python::Virtualenv

  desc "Terminal based YouTube player and downloader"
  homepage "https://github.com/mps-youtube/mps-youtube"
  url "https://github.com/mps-youtube/mps-youtube/archive/v0.2.8.tar.gz"
  sha256 "d5f2c4bc1f57f0566242c4a0a721a5ceaa6d6d407f9d6dd29009a714a0abec74"
  revision 6

  bottle do
    cellar :any_skip_relocation
    sha256 "d840372d6f1a259e06892a123924c0b464348b41f8fe8f2ec0ba6128595b748b" => :mojave
    sha256 "507ee71c4817b80135c9a3db7fb12a1dea24ea2b89f7fb01535f69815eee402e" => :high_sierra
    sha256 "1cb85cd1242925f28ad50ae42a9718f0fe58af4d51ab70f236342a4f4ae21832" => :sierra
  end

  depends_on "mpv"
  depends_on "python"

  resource "pafy" do
    url "https://files.pythonhosted.org/packages/41/cb/ec840c79942fb0788982963b61a361ecd10e4e58ad3dcaef4f0e809ce2fe/pafy-0.5.4.tar.gz"
    sha256 "e842dc589a339a870b5869cc3802f2e95824edf347f65128223cd5ebdff21024"
  end

  resource "youtube_dl" do
    url "https://files.pythonhosted.org/packages/48/15/e73763a475242a480f9b547e1dc8f686a030c84d022f59f8b92bb1953584/youtube_dl-2019.1.17.tar.gz"
    sha256 "864af477bd5eb683b9992270544d98ae865aedc32a04b103d6eaab2041242fb5"
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
