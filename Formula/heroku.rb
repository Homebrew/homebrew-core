class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://cli-assets.heroku.com/heroku-cli/channels/stable/heroku-cli-v6.11.14-c5f9179-darwin-x64.tar.xz"
  version "6.11.14"
  sha256 "f032ac4cf47f7ed5660db6a32bc5955ac7f939c8b7246cdf68dce7105bc5d18b"

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
