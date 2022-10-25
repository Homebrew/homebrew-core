class DockerSlim < Formula
  desc "Minify and secure Docker images"
  homepage "https://dockersl.im"
  url "https://github.com/docker-slim/docker-slim/archive/1.39.0.tar.gz"
  sha256 "3574952b1d8ff340af3f9ed58d6a22f0f8d81ac043ea73b8d2e5eca80fedefce"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a61b691d47477b71128b2a37f5fd589545092d47014319dfa28aa1a5b32d9e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a61b691d47477b71128b2a37f5fd589545092d47014319dfa28aa1a5b32d9e9"
    sha256 cellar: :any_skip_relocation, monterey:       "3bf1b372a5e89917bb90d548320aa23f6e846481c6ec7c75f072ce6fdbb79b7a"
    sha256 cellar: :any_skip_relocation, big_sur:        "3bf1b372a5e89917bb90d548320aa23f6e846481c6ec7c75f072ce6fdbb79b7a"
    sha256 cellar: :any_skip_relocation, catalina:       "3bf1b372a5e89917bb90d548320aa23f6e846481c6ec7c75f072ce6fdbb79b7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e7bae4baca28f96c8de2e548464fb0c6fc5c00ca255454bca0a501be74706ff"
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
