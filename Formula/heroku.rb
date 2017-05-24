class Heroku < Formula
  desc "Everything you need to get started with Heroku"
  homepage "https://cli.heroku.com"
  url "https://cli-assets.heroku.com/heroku-cli/channels/stable/heroku-cli-v6.6.17-f15d070-darwin-x64.tar.xz"
  version "6.6.17"
  sha256 "a6e6cd7ca302dbaa8f9388008076c5e8807d3a59120c69f7fd5411564f773d3f"

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
