class DockerSlim < Formula
  desc "Minify and secure Docker images"
  homepage "https://dockersl.im"
  url "https://github.com/docker-slim/docker-slim/archive/1.29.0.tar.gz"
  sha256 "538f623dde86d1cfeef4e645cf05260677dfc1f434c9596e54b0409669a4f1c5"

  bottle do
    cellar :any_skip_relocation
    sha256 "197bd44584e5181aa36e0d12ad8265ea0eb6d7586eaea5bdb2de35b92eb202a9" => :catalina
    sha256 "197bd44584e5181aa36e0d12ad8265ea0eb6d7586eaea5bdb2de35b92eb202a9" => :mojave
    sha256 "197bd44584e5181aa36e0d12ad8265ea0eb6d7586eaea5bdb2de35b92eb202a9" => :high_sierra
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
