class Heroku < Formula
  desc "Everything you need to get started with Heroku"
  homepage "https://cli.heroku.com"
  url "https://cli-assets.heroku.com/branches/stable/5.8.5-614a805/heroku-v5.8.5-614a805-darwin-amd64.tar.xz"
  version "5.8.5"
  sha256 "9f108c351f887866d9887169069740648006459575e4064e7c810c46da27cb0b"

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
