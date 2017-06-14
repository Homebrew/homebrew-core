class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://cli-assets.heroku.com/heroku-cli/channels/stable/heroku-cli-v6.11.3-7bdd26d-darwin-x64.tar.xz"
  version "6.11.3"
  sha256 "018ab02d660fb992fa928f8791e78136f7b9e88df94935f7f788cb6df1476780"

  bottle :unneeded

  depends_on :arch => :x86_64

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/heroku"
  end

  test do
    system bin/"heroku", "version"
  end
end
