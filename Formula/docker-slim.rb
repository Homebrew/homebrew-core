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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b6a013831cf0f8d3c2bcd560a1294c4a0382e178f8e692e1e8564fcf95f2fd2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b6a013831cf0f8d3c2bcd560a1294c4a0382e178f8e692e1e8564fcf95f2fd2"
    sha256 cellar: :any_skip_relocation, monterey:       "88edfbf34c89bf14c1769bc56925689b85f81dab329afb06e014b362289ba606"
    sha256 cellar: :any_skip_relocation, big_sur:        "88edfbf34c89bf14c1769bc56925689b85f81dab329afb06e014b362289ba606"
    sha256 cellar: :any_skip_relocation, catalina:       "88edfbf34c89bf14c1769bc56925689b85f81dab329afb06e014b362289ba606"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63fd4c0005aec6def5ac502c93130e7d6bb248b9fb23f572918adea608ee85b7"
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
