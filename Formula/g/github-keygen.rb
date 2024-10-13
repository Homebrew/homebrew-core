class GithubKeygen < Formula
  desc "Bootstrap GitHub SSH configuration"
  homepage "https://github.com/dolmen/github-keygen"
  url "https://github.com/dolmen/github-keygen/archive/refs/tags/v1.306.tar.gz"
  sha256 "69fc7ef1bf5c4e958f2ad634a8cc21ec4905b16851e46455c47f9ef7a7220f5d"
  license "GPL-3.0-or-later"
  head "https://github.com/dolmen/github-keygen.git", branch: "release"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "5a44d2a88e85b0bdf5295eb909e89bb59d23061fff128759100f1565521f05ad"
  end

  def install
    bin.install "github-keygen"
  end

  test do
    system bin/"github-keygen"
  end
end
