class Heroku < Formula
  desc "Everything you need to get started with Heroku"
  homepage "https://cli.heroku.com"
  url "https://cli-assets.heroku.com/heroku-cli/channels/stable/heroku-cli-v6.9.3-f709986-darwin-x64.tar.xz"
  version "6.9.3"
  sha256 "ffdc87b1e2910893a28ac04da42fdd2fa808b099b3450f7427b091dc2679c378"

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
