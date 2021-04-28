class DockerSlim < Formula
  desc "Minify and secure Docker images"
  homepage "https://dockersl.im"
  url "https://github.com/docker-slim/docker-slim/archive/1.35.0.tar.gz"
  sha256 "a623513a476d897f1bd98bab9c460772c3b1374cb6928d7ddabb7070a0e2ab4c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "aa83917219351901e66a533d70147b7f9cecdf98f53c8839755e75907786d62d"
    sha256 cellar: :any_skip_relocation, big_sur:       "2760413280d87d7b2979a4196909dc52de41e502c83753b21f37238b23ff5b5f"
    sha256 cellar: :any_skip_relocation, catalina:      "2760413280d87d7b2979a4196909dc52de41e502c83753b21f37238b23ff5b5f"
    sha256 cellar: :any_skip_relocation, mojave:        "2760413280d87d7b2979a4196909dc52de41e502c83753b21f37238b23ff5b5f"
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
