class DockerSlim < Formula
  desc "Minify and secure Docker images"
  homepage "https://dockersl.im"
  url "https://github.com/docker-slim/docker-slim/archive/1.37.5.tar.gz"
  sha256 "e395a8865fb888a190032783ee0a9f1a5ac9a13c296b9bd0c503fe81937eed18"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83ae2be6bd562026b11e9a9b0ab03d8ae1de5432d7285ef5dfb4e498471c3681"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83ae2be6bd562026b11e9a9b0ab03d8ae1de5432d7285ef5dfb4e498471c3681"
    sha256 cellar: :any_skip_relocation, monterey:       "ed6fe3c490851d2d2e40f1de876f89130b906fa6a70d7788f2db8d953db3efaf"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed6fe3c490851d2d2e40f1de876f89130b906fa6a70d7788f2db8d953db3efaf"
    sha256 cellar: :any_skip_relocation, catalina:       "ed6fe3c490851d2d2e40f1de876f89130b906fa6a70d7788f2db8d953db3efaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7180fc9ad6e393b235cbd6da0aacea48eab145665ad3f4b78868c4ceba03a34"
  end

  depends_on "go" => :build

  skip_clean "bin/docker-slim-sensor"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X github.com/docker-slim/docker-slim/pkg/version.appVersionTag=#{version}"
    system "go", "build", "-trimpath", "-ldflags=#{ldflags}", "-o",
           bin/"docker-slim", "./cmd/docker-slim"

    # docker-slim-sensor is a Linux binary that is used within Docker
    # containers rather than directly on the macOS host.
    ENV["GOOS"] = "linux"
    system "go", "build", "-trimpath", "-ldflags=#{ldflags}", "-o",
           bin/"docker-slim-sensor", "./cmd/docker-slim-sensor"
    (bin/"docker-slim-sensor").chmod 0555
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-slim --version")
    system "test", "-x", bin/"docker-slim-sensor"
  end
end
