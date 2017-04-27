class Heroku < Formula
  desc "Everything you need to get started with Heroku"
  homepage "https://cli.heroku.com"
  url "https://cli-assets.heroku.com/branches/stable/5.8.11-0e9b5ce/heroku-v5.8.11-0e9b5ce-darwin-amd64.tar.xz"
  version "5.8.11"
  sha256 "613544bf6b9585ee5f453471543984f847325575d5c95e91a46a4b8b2a10cf70"

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
