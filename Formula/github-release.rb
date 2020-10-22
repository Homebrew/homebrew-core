class GithubRelease < Formula
  desc "Create and edit releases on Github (and upload artifacts)"
  homepage "https://github.com/github-release/github-release"
  url "https://github.com/github-release/github-release/archive/v0.9.0.tar.gz"
  sha256 "d421bee3af352ab79058d1e37b8f97d0772f890cd850ae2a21a7060e81985e1f"
  license "MIT"
  head "https://github.com/github-release/github-release.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "67399d81e62c8b1fb7d5b26ebea79de5d806757cd194d2055dcd5dc8935167e2" => :catalina
    sha256 "3640960eb97bed10dfe75237cc61b3e8fb36f526c9d50c6820cd07c841432842" => :mojave
    sha256 "53b5ef103a6190a891f53a5c52019ab2e12e31f15f4f97775cb2cb169befefa1" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "make"
    bin.install "github-release"
  end

  test do
    system "#{bin}/github-release", "info", "--user", "github-release",
                                            "--repo", "github-release",
                                            "--tag", "v#{version}"
  end
end
