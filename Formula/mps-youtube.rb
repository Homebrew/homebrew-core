class MpsYoutube < Formula
  include Language::Python::Virtualenv

  desc "Terminal based YouTube player and downloader"
  homepage "https://github.com/mps-youtube/mps-youtube"
  url "https://github.com/mps-youtube/mps-youtube/archive/v0.2.8.tar.gz"
  sha256 "d5f2c4bc1f57f0566242c4a0a721a5ceaa6d6d407f9d6dd29009a714a0abec74"
  revision 10

  bottle do
    cellar :any_skip_relocation
    sha256 "4bd9882d37990b6248a1c66e2a5a811ec56623137bce402349f6d3f0b26b266e" => :catalina
    sha256 "010336617d49531753133de6b438ff69d3e34d49b72caaa356e9c7e5260db814" => :mojave
    sha256 "bbb8c699b6bab92ac2cef47608a8d5dc5bd110a04e842d5720620b0c9793c060" => :high_sierra
  end

  depends_on "mplayer"
  depends_on "python@3.8"

  resource "pafy" do
    url "https://files.pythonhosted.org/packages/7e/02/b70f4d2ad64bbc7d2a00018c6545d9b9039208553358534e73e6dd5bbaf6/pafy-0.5.5.tar.gz"
    sha256 "364f1d1312c89582d97dc7225cf6858cde27cb11dfd64a9c2bab1a2f32133b1e"
  end

  resource "youtube_dl" do
    url "https://files.pythonhosted.org/packages/51/80/d3938814a40163d3598f8a1ced6abd02d591d9bb38e66b3229aebe1e2cd0/youtube_dl-2020.5.3.tar.gz"
    sha256 "e7a400a61e35b7cb010296864953c992122db4b0d6c9c6e2630f3e0b9a655043"
  end

  def install
    venv = virtualenv_create(libexec, "python3.8")

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
