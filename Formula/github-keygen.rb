class GithubKeygen < Formula
  desc "Bootstrap GitHub SSH configuration"
  homepage "https://github.com/dolmen/github-keygen"
  url "https://github.com/dolmen/github-keygen/archive/v1.300.tar.gz"
  sha256 "8eb10e2c632e7119176031b8b0145668ee67e4cb1b53d08b7d27a152a28ea61a"
  head "https://github.com/dolmen/github-keygen.git"

  bottle :unneeded

  def install
    bin.install "github-keygen"
  end

  test do
    system "#{bin}/github-keygen"
  end
end
