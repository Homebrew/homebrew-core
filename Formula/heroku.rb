class Heroku < Formula
  desc "Everything you need to get started with Heroku"
  homepage "https://cli.heroku.com"
  url "https://cli-assets.heroku.com/branches/stable/5.6.1-0976cf3/heroku-v5.6.1-0976cf3-darwin-amd64.tar.xz"
  version "5.6.1-0976cf3"
  sha256 "27994f23258ef21c0e40b9fa21fc24b5fcabc44c697c07bf2883fb9b6fc65869"

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
