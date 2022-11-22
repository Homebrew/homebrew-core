class MpsYoutube < Formula
  include Language::Python::Virtualenv

  desc "Terminal based YouTube player and downloader"
  homepage "https://github.com/mps-youtube/mps-youtube"
  url "https://files.pythonhosted.org/packages/b1/8e/5156416119545e3f5ba16ec0fdbb2c7d0b57fad9e19ee8554856cd4a41ad/mps-youtube-0.2.8.tar.gz"
  sha256 "59ce3944626fbd1a041e1e1b15714bbd138ebc71ceb89e32ea9470d8152af083"
  license "GPL-3.0-or-later"
  revision 12

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "978333f648bbc75f2d95b6b096b0ba21f094d88076f0c148cdeb2ffaf542d3ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8836a41e83de7ffe7e9d3f804b67f7b2f6f0581cef0a63a944f01833fd11dc8c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8836a41e83de7ffe7e9d3f804b67f7b2f6f0581cef0a63a944f01833fd11dc8c"
    sha256 cellar: :any_skip_relocation, ventura:        "33ee577a62f2a89a924160b28f4747b78b7d6e94bca85d0723c00a1569447788"
    sha256 cellar: :any_skip_relocation, monterey:       "4427c42e4efe37f8c550288610f1404a88d3124815cd19d5749eafbf9a9d6272"
    sha256 cellar: :any_skip_relocation, big_sur:        "4427c42e4efe37f8c550288610f1404a88d3124815cd19d5749eafbf9a9d6272"
    sha256 cellar: :any_skip_relocation, catalina:       "4427c42e4efe37f8c550288610f1404a88d3124815cd19d5749eafbf9a9d6272"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5b3fcc9a61653e8cdaa4ae05ef4c8e2fd4edaec0a79a48481ee625adf080b0e"
  end

  depends_on "mplayer"
  depends_on "python@3.10"

  resource "pafy" do
    url "https://files.pythonhosted.org/packages/7e/02/b70f4d2ad64bbc7d2a00018c6545d9b9039208553358534e73e6dd5bbaf6/pafy-0.5.5.tar.gz"
    sha256 "364f1d1312c89582d97dc7225cf6858cde27cb11dfd64a9c2bab1a2f32133b1e"
  end

  resource "youtube_dl" do
    url "https://files.pythonhosted.org/packages/51/80/d3938814a40163d3598f8a1ced6abd02d591d9bb38e66b3229aebe1e2cd0/youtube_dl-2020.5.3.tar.gz"
    sha256 "e7a400a61e35b7cb010296864953c992122db4b0d6c9c6e2630f3e0b9a655043"
  end

  def install
    venv = virtualenv_create(libexec, "python3.10")

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
