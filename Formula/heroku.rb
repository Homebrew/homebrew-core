class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://cli-assets.heroku.com/heroku-cli/channels/stable/heroku-cli-v6.12.3-fca882c-darwin-x64.tar.xz"
  version "6.12.3"
  sha256 "926462a2086bde11dcfc940157bd91de6376e9c2cdc6bdade6a9143b205a8886"

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
