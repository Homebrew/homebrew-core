class Heroku < Formula
  desc "Everything you need to get started with Heroku"
  homepage "https://cli.heroku.com"
  url "https://cli-assets.heroku.com/branches/stable/5.6.11-3b6a56e/heroku-v5.6.11-3b6a56e-darwin-amd64.tar.xz"
  version "5.6.11-3b6a56e"
  sha256 "a69969374ca559f0f1e76905ef6ae856280d2cce859e7cd68357c201ef96a99d"

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
