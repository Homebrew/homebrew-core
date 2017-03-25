class GithubRelease < Formula
  desc "Create and edit releases on Github (and upload artifacts)"
  homepage "https://github.com/aktau/github-release"
  url "https://github.com/aktau/github-release/archive/v0.6.3.tar.gz"
  sha256 "d72c614fae6603b60f3fb4b7473cb9f0ed6d592d8804729542481b5602fe6de1"
  head "https://github.com/aktau/github-release.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "43ff0e8f4ffd6329586c55a94b789f8a000f42a1e2dd6b739676cad098ede12b" => :sierra
    sha256 "da81d46e83c078b2676a744f14a3e045264f92923e95160faf65f702de3bfd61" => :el_capitan
    sha256 "1ae83d9d5f18aeb437409199200b8bc95d7a8eaefd3d815457a7ec079ef1bdcd" => :yosemite
    sha256 "7023a11e0dbe16b7bbdafdc784a1ad28488251f1c17ecfb010542ce0c64a54e7" => :mavericks
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
