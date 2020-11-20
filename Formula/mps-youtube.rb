class MpsYoutube < Formula
  include Language::Python::Virtualenv

  desc "Terminal based YouTube player and downloader"
  homepage "https://github.com/mps-youtube/mps-youtube"
  url "https://github.com/mps-youtube/mps-youtube/archive/v0.2.8.tar.gz"
  sha256 "d5f2c4bc1f57f0566242c4a0a721a5ceaa6d6d407f9d6dd29009a714a0abec74"
  license "GPL-3.0"
  revision 11

  bottle do
    cellar :any_skip_relocation
    sha256 "b9077de1d446678ff5a91d341257636a8c6b59e818b1843fc1f7f14a3a568718" => :big_sur
    sha256 "18d91d027af3797a33a1dce5cd5677045539a1c9664fd5d1e70b000f3baa0298" => :catalina
    sha256 "51c856bc1f5cdfe4b71c8315277d17fdfb3202afcc20c0816a1c884b14b10fde" => :mojave
    sha256 "812e64456b7e8cce5ede6fb043c904d78d6b16c8d92c8d33f620b7b85ac10984" => :high_sierra
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
        brew cask install mpv
    EOS
  end

  test do
    Open3.popen3("#{bin}/mpsyt", "/Drop4Drop x Ed Sheeran,", "da 1,", "q") do |_, _, stderr|
      assert_empty stderr.read, "Some warnings were raised"
    end
  end
end
