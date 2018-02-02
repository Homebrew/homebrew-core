class GithubKeygen < Formula
  desc "Bootstrap GitHub SSH configuration"
  homepage "https://github.com/dolmen/github-keygen"
  url "https://github.com/dolmen/github-keygen/archive/v1.304.tar.gz"
  sha256 "463b630e395bddad8cc570bd93f5fb42d4d3b6b68de7724cac536381f18b3567"
  head "https://github.com/dolmen/github-keygen.git"

  bottle :unneeded

  def install
    bin.install "github-keygen"
  end

  test do
    system "#{bin}/github-keygen"
  end
end
