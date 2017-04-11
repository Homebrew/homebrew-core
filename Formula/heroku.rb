class Heroku < Formula
  desc "Everything you need to get started with Heroku"
  homepage "https://cli.heroku.com"
  url "https://cli-assets.heroku.com/branches/stable/5.8.3-6e0825b/heroku-v5.8.3-6e0825b-darwin-amd64.tar.xz"
  version "5.8.3-6e0825b"
  sha256 "44273d3998910636f20008ce7901ccb8e180520cc5a7e4779d4ea4401c492119"

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
