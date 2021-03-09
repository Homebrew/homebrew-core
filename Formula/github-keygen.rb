class GithubKeygen < Formula
  desc "Bootstrap GitHub SSH configuration"
  homepage "https://github.com/dolmen/github-keygen"
  url "https://github.com/dolmen/github-keygen/archive/v1.305.tar.gz"
  sha256 "5a0a68ed9e3eb1c0e3b783c250e0790fffe17fc1a663cefa1348560ff040b940"
  license "GPL-3.0"
  head "https://github.com/dolmen/github-keygen.git"

  bottle :unneeded

  def install
    bin.install "github-keygen"
  end

  test do
    system "#{bin}/github-keygen"
  end
end
