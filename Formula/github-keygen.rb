class GithubKeygen < Formula
  desc "Bootstrap GitHub SSH configuration"
  homepage "https://github.com/dolmen/github-keygen"
  url "https://github.com/dolmen/github-keygen/archive/v1.306.tar.gz"
  sha256 "69fc7ef1bf5c4e958f2ad634a8cc21ec4905b16851e46455c47f9ef7a7220f5d"
  license "GPL-3.0"
  head "https://github.com/dolmen/github-keygen.git", branch: "release"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "136695a8f7aabb99fe75ad524d6143d8998a27b136971513c5e58853ee7d4d95"
  end

  def install
    bin.install "github-keygen"
  end

  test do
    system "#{bin}/github-keygen"
  end
end
