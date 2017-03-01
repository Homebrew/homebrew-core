class Heroku < Formula
  desc "Everything you need to get started with Heroku"
  homepage "https://cli.heroku.com"
  url "https://cli-assets.heroku.com/branches/stable/5.6.28-2643c0a/heroku-v5.6.28-2643c0a-darwin-amd64.tar.xz"
  version "5.6.28-2643c0a"
  sha256 "7d0320800410821349a0f44be1ca49619388ef934e3ae2334b7c6b1f5028da95"

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
