class Heroku < Formula
  desc "Everything you need to get started with Heroku"
  homepage "https://cli.heroku.com"
  url "https://cli-assets.heroku.com/heroku-cli/channels/stable/heroku-cli-v6.7.4-97fc5c6-darwin-x64.tar.xz"
  version "6.7.4"
  sha256 "5660eff0521837a10e78a91234945b3dfe3a31b9bc786c80ba0c11c3ff0ff339"

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
