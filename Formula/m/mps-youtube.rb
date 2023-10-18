class MpsYoutube < Formula
  include Language::Python::Virtualenv

  desc "Terminal based YouTube player and downloader"
  homepage "https://github.com/mps-youtube/mps-youtube"
  url "https://files.pythonhosted.org/packages/b1/8e/5156416119545e3f5ba16ec0fdbb2c7d0b57fad9e19ee8554856cd4a41ad/mps-youtube-0.2.8.tar.gz"
  sha256 "59ce3944626fbd1a041e1e1b15714bbd138ebc71ceb89e32ea9470d8152af083"
  license "GPL-3.0-or-later"
  revision 12

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "71e781a593e259f5de0ab1f26553a0b6879d859ec2fc719213e44c4fa840ed16"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34b87b2545d398fbda0fa4d275a171a952f4d7c9cf62b0ab1c3b2920b0cf446f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34b87b2545d398fbda0fa4d275a171a952f4d7c9cf62b0ab1c3b2920b0cf446f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34b87b2545d398fbda0fa4d275a171a952f4d7c9cf62b0ab1c3b2920b0cf446f"
    sha256 cellar: :any_skip_relocation, sonoma:         "5f2dc0ba04fb7cfca027c2dfb2c25f59b6ac79457b090aabc38e068e747d6d9b"
    sha256 cellar: :any_skip_relocation, ventura:        "17af74c4e50533a28f381707209239aca41abb4cd5af1653dbe6bf40ba008fcd"
    sha256 cellar: :any_skip_relocation, monterey:       "17af74c4e50533a28f381707209239aca41abb4cd5af1653dbe6bf40ba008fcd"
    sha256 cellar: :any_skip_relocation, big_sur:        "17af74c4e50533a28f381707209239aca41abb4cd5af1653dbe6bf40ba008fcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "331211aeb8d3a9c6a22c4fe525a67b3197b373143bc02b933ecc91f5eaff0151"
  end

  depends_on "mplayer"
  depends_on "python@3.11"

  resource "pafy" do
    url "https://files.pythonhosted.org/packages/7e/02/b70f4d2ad64bbc7d2a00018c6545d9b9039208553358534e73e6dd5bbaf6/pafy-0.5.5.tar.gz"
    sha256 "364f1d1312c89582d97dc7225cf6858cde27cb11dfd64a9c2bab1a2f32133b1e"
  end

  resource "youtube-dl" do
    url "https://files.pythonhosted.org/packages/51/80/d3938814a40163d3598f8a1ced6abd02d591d9bb38e66b3229aebe1e2cd0/youtube_dl-2020.5.3.tar.gz"
    sha256 "e7a400a61e35b7cb010296864953c992122db4b0d6c9c6e2630f3e0b9a655043"
  end

  def install
    venv = virtualenv_create(libexec, "python3.11")

    %w[youtube-dl pafy].each do |r|
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
