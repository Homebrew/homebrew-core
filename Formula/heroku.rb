class Heroku < Formula
  desc "Everything you need to get started with Heroku"
  homepage "https://cli.heroku.com"
  url "https://cli-assets.heroku.com/heroku-cli/channels/stable/heroku-cli-v6.6.18-1a1fd10-darwin-x64.tar.xz"
  version "6.6.18"
  sha256 "e47e428adfd9c16b8bff6668c7671e4fe679aac94285457d6999f80aff8edc2a"

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
