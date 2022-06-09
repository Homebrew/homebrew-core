class GithubKeygen < Formula
  desc "Bootstrap GitHub SSH configuration"
  homepage "https://github.com/dolmen/github-keygen"
  url "https://github.com/dolmen/github-keygen/archive/v1.306.tar.gz"
  sha256 "69fc7ef1bf5c4e958f2ad634a8cc21ec4905b16851e46455c47f9ef7a7220f5d"
  license "GPL-3.0"
  head "https://github.com/dolmen/github-keygen.git", branch: "release"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "40efaefeb31f64b474d8030ddc268250d52d6f3e17131f36d0eb8e35fa24ab8e"
  end

  def install
    bin.install "github-keygen"
  end

  test do
    system "#{bin}/github-keygen"
  end
end
