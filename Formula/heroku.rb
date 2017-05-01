class Heroku < Formula
  desc "Everything you need to get started with Heroku"
  homepage "https://cli.heroku.com"
  url "https://cli-assets.heroku.com/branches/stable/5.9.0-1b8deac/heroku-v5.9.0-1b8deac-darwin-amd64.tar.xz"
  version "5.9.0"
  sha256 "37a578261bad805788a24acbb76cf70adef258b5ee4d75894af3691dcc73f02e"

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
