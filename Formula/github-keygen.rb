class GithubKeygen < Formula
  desc "Bootstrap GitHub SSH configuration"
  homepage "https://github.com/dolmen/github-keygen"
  url "https://github.com/dolmen/github-keygen/archive/v1.303.tar.gz"
  sha256 "793102fecef05f460268de2ed68635b764c22f83ebde864de17576e12e5d92aa"
  head "https://github.com/dolmen/github-keygen.git"

  bottle :unneeded

  def install
    bin.install "github-keygen"
  end

  test do
    system "#{bin}/github-keygen"
  end
end
