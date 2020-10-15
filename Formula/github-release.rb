class GithubRelease < Formula
  desc "Create and edit releases on Github (and upload artifacts)"
  homepage "https://github.com/github-release/github-release"
  url "https://github.com/github-release/github-release/archive/v0.8.1.tar.gz"
  sha256 "c32d615e94cfa1d7c64af5ca84820bfc6193c867b0e9041b4e21b40f0b3df307"
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
