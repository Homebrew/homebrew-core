class GithubRelease < Formula
  desc "Create and edit releases on Github (and upload artifacts)"
  homepage "https://github.com/aktau/github-release"
  url "https://github.com/aktau/github-release/archive/v0.6.4.tar.gz"
  sha256 "c310bb566a4b8717b781947effcbb79dd4e64972b732efb8c3eb330b527e6263"
  head "https://github.com/aktau/github-release.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd9b81442cd8ceefe325badad141aaf30d1f1b2c3bf0a38b07d22c78e1ec2a67" => :sierra
    sha256 "bda997f261e7a20883e8c5683af8bfd24b940fa5f13e66b12ebf6133c5b8e4b9" => :el_capitan
    sha256 "41a9c67110e5ecf48d357d7fffcf84ecca69c97c5e9d9e1ceb86195bead665ea" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "make"
    bin.install "github-release"
  end

  test do
    system "#{bin}/github-release", "info", "--user", "aktau",
                                            "--repo", "github-release",
                                            "--tag", "v#{version}"
  end
end
