class MpsYoutube < Formula
  include Language::Python::Virtualenv

  desc "Terminal based YouTube player and downloader"
  homepage "https://github.com/mps-youtube/mps-youtube"
  url "https://files.pythonhosted.org/packages/b1/8e/5156416119545e3f5ba16ec0fdbb2c7d0b57fad9e19ee8554856cd4a41ad/mps-youtube-0.2.8.tar.gz"
  sha256 "59ce3944626fbd1a041e1e1b15714bbd138ebc71ceb89e32ea9470d8152af083"
  license "GPL-3.0-or-later"
  revision 11

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, monterey:     "f6a624aa18d27deef6af3a51d5f4bf9aecb8365efe73d7307568bb54fd204725"
    sha256 cellar: :any_skip_relocation, big_sur:      "2dd08756b9e62a90560e745bc04c143746d814083d4718e8b54907f7afd13403"
    sha256 cellar: :any_skip_relocation, catalina:     "4e9a341a4d730d6b3ded045d3db8fc3bed53c181c380cb412c8ca87af512cb49"
    sha256 cellar: :any_skip_relocation, mojave:       "7447cf6a16ec67bcfd0c11ede83ff5c2b91f4c8aebb12cd125f3c242473933e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "50e8db839abc32629d5defe0b61efb71264de0841d30b3b0f3bb35a14af879a3"
  end

  depends_on "mplayer"
  depends_on "python@3.9"

  resource "pafy" do
    url "https://files.pythonhosted.org/packages/7e/02/b70f4d2ad64bbc7d2a00018c6545d9b9039208553358534e73e6dd5bbaf6/pafy-0.5.5.tar.gz"
    sha256 "364f1d1312c89582d97dc7225cf6858cde27cb11dfd64a9c2bab1a2f32133b1e"
  end

  resource "youtube_dl" do
    url "https://files.pythonhosted.org/packages/51/80/d3938814a40163d3598f8a1ced6abd02d591d9bb38e66b3229aebe1e2cd0/youtube_dl-2020.5.3.tar.gz"
    sha256 "e7a400a61e35b7cb010296864953c992122db4b0d6c9c6e2630f3e0b9a655043"
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
        brew install --cask mpv
    EOS
  end

  test do
    Open3.popen3("#{bin}/mpsyt", "/Drop4Drop x Ed Sheeran,", "da 1,", "q") do |_, _, stderr|
      assert_empty stderr.read, "Some warnings were raised"
    end
  end
end
