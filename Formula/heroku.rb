class Heroku < Formula
  desc "Everything you need to get started with Heroku"
  homepage "https://cli.heroku.com"
  url "https://cli-assets.heroku.com/heroku-cli/channels/stable/heroku-cli-v6.7.2-bb6e0ee-darwin-x64.tar.xz"
  version "6.7.2"
  sha256 "1ba17943d63354a58d0c2cd4c33e08cd91f991df8e9d834eec6a536fafef04fb"

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
