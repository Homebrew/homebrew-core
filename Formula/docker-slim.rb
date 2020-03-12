class DockerSlim < Formula
  desc "Minify and secure Docker images"
  homepage "https://dockersl.im"
  url "https://github.com/docker-slim/docker-slim/archive/1.28.0.tar.gz"
  sha256 "a6a88bf826dd8bf74ebead55dddfaad1977fae3885c7ec1bdacf4268e9e8d7f2"

  bottle do
    cellar :any_skip_relocation
    sha256 "6faee22c4f3a09aa571f26156d78eecc3f2a33fa26a6207e7197d250b1d4b904" => :catalina
    sha256 "6faee22c4f3a09aa571f26156d78eecc3f2a33fa26a6207e7197d250b1d4b904" => :mojave
    sha256 "6faee22c4f3a09aa571f26156d78eecc3f2a33fa26a6207e7197d250b1d4b904" => :high_sierra
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
