class Heroku < Formula
  desc "Everything you need to get started with Heroku"
  homepage "https://cli.heroku.com"
  url "https://cli-assets.heroku.com/heroku-cli/channels/stable/heroku-cli-v6.6.7-ecf0119-darwin-x64.tar.xz"
  version "6.6.7"
  sha256 "52687425b0044e0b086e8c577f081f0d027f73c1b9bb0ac59740864d051dba2f"

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
