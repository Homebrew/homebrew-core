class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.74.5.tar.gz"
  sha256 "ec87f5de0e4b2e0c4c967619a658078285d995dd8d1c1ab02e51e3ca6ee06cdf"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "869d4bca01b83da39a0502c65c2f2df87b902799c2995dec709deca38ed5587e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acc713f3cf84564dc975ef379207dde4975a62a9b6cf4d59db605d70b28be537"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e96337c0d8de6a5acfdba4b9728ab1bbf159678372863f3dee101c1e9274ece"
    sha256 cellar: :any_skip_relocation, sonoma:         "723b78d392b67b3854081e55749eb81e0b58aa390d8e2fb1b65c2188ce276265"
    sha256 cellar: :any_skip_relocation, ventura:        "de1cdf60049e1bc889e128d15fb5d84e8cf11aa2f5def31c61b55ee64309b0c0"
    sha256 cellar: :any_skip_relocation, monterey:       "57b122468ceb068147f45bfbf0ba9bf2cffef4cda8d35928606b11b23070e87c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a6deffff71f53421a1ac3585214f71a5cb5a1666643870a6f0e7c537e687663"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version")
  end
end
