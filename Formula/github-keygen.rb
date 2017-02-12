class GithubKeygen < Formula
  desc "Bootstrap GitHub SSH configuration"
  homepage "https://github.com/dolmen/github-keygen"
  url "https://github.com/dolmen/github-keygen/archive/v1.302.tar.gz"
  sha256 "cc703512ab67837a7025e7d018731e97ddc6a943f87ccd8620986d5757991a48"
  head "https://github.com/dolmen/github-keygen.git"

  bottle :unneeded

  def install
    bin.install "github-keygen"
  end

  test do
    system "#{bin}/github-keygen"
  end
end
