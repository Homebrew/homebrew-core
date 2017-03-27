class GithubRelease < Formula
  desc "Create and edit releases on Github (and upload artifacts)"
  homepage "https://github.com/aktau/github-release"
  url "https://github.com/aktau/github-release/archive/v0.7.0.tar.gz"
  sha256 "af870c97e8bc3f611f764eec1089e1d70a650b807e465ea6c14a231d77bb091c"
  head "https://github.com/aktau/github-release.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef4477e6950f0def9528cda3effe42e5a31725f7379ea568bd1a9d50ae7481a5" => :sierra
    sha256 "faf00dfd2c510001d92f25e11fe10509b5dbe9ff846c2957fc208954c7c2a23b" => :el_capitan
    sha256 "3cff556d724221a62e1af368351f8bab202d900549815884d25de3a2341ca23d" => :yosemite
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
