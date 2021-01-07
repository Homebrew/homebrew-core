class GithubRelease < Formula
  desc "Create and edit releases on Github (and upload artifacts)"
  homepage "https://github.com/github-release/github-release"
  url "https://github.com/github-release/github-release/archive/v0.10.0.tar.gz"
  sha256 "79bfaa465f549a08c781f134b1533f05b02f433e7672fbaad4e1764e4a33f18a"
  license "MIT"
  head "https://github.com/github-release/github-release.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "be80f9385a3b69fcbcdd68020ce392831e94aa5f9079fdea0989907b7ccc0e4c" => :big_sur
    sha256 "55ca08b3981304bfdeea12ce4cec19b75bb56e0c502060211eb360774bfddc47" => :catalina
    sha256 "753179f81586312d394ab636eccc14a67af766f37b1056030bff7b9bfa7fad7a" => :mojave
    sha256 "c0a159a17d1b68a20581a048267c228bc242db00e36cd8bc3221a26dea2f0488" => :high_sierra
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
