class GithubRelease < Formula
  desc "Create and edit releases on Github (and upload artifacts)"
  homepage "https://github.com/aktau/github-release"
  url "https://github.com/aktau/github-release/archive/v0.6.4.tar.gz"
  sha256 "c310bb566a4b8717b781947effcbb79dd4e64972b732efb8c3eb330b527e6263"
  head "https://github.com/aktau/github-release.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a013de6f65465c3bd4edea94e2c214b8f7b05c5790d05d2cc82aa7e9c055f8e" => :sierra
    sha256 "677322d554fd1006ce01b0ad69ad8c3d4500b914f35c49adac0d5db74f454b12" => :el_capitan
    sha256 "7a803c171f8e2f2595b670da31840f1121c370e35d309aa31048be6b1353340e" => :yosemite
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
