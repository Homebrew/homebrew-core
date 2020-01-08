class GithubRelease < Formula
  desc "Create and edit releases on Github (and upload artifacts)"
  homepage "https://github.com/aktau/github-release"
  url "https://github.com/aktau/github-release/archive/v0.7.2.tar.gz"
  sha256 "057d57b01cd45d0316e2d32b7593ff0f4bb493d4767b5701b21b54301d74ff48"
  head "https://github.com/aktau/github-release.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "886fb439e27d1a2e35e5210c8f12cac022eb8bc8e5159fcf7786ece53aa2e948" => :catalina
    sha256 "3846d1e036390625cc978d6bc031892df97d2864cc725988ceda3c1b8e3111c1" => :mojave
    sha256 "3ed39e92f9c191954107c1b85c9b22071fb68a1082f3c55de21d34f3d168bb2b" => :high_sierra
    sha256 "e94b764f5aaf43c51cbd03702d3a645ea572d797578f8ece2e1a582055782e9b" => :sierra
    sha256 "a8a9c18b04a892300a0594f96dbd79862915522ab7f23c4e125a3334a660d16b" => :el_capitan
    sha256 "4fa1eefc30b795cb2b49f7f15505d1d625aa2bbff9f2e06d39c9b8f2c29bd21a" => :yosemite
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
