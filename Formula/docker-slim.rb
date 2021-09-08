class DockerSlim < Formula
  desc "Minify and secure Docker images"
  homepage "https://dockersl.im"
  url "https://github.com/docker-slim/docker-slim/archive/1.36.4.tar.gz"
  sha256 "749ba64c2f21efde3480adf96284ba43a99ecd53c39deb779fa48ac329aa19c3"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d7fe324dd837b56f9eb610850e3ae0af123a64b16e2bc1617ecec366f55585e1"
    sha256 cellar: :any_skip_relocation, big_sur:       "b26187e10d9c9648b373065d01e03a5674e65fd177408d42e833cdd2f0c7701a"
    sha256 cellar: :any_skip_relocation, catalina:      "b26187e10d9c9648b373065d01e03a5674e65fd177408d42e833cdd2f0c7701a"
    sha256 cellar: :any_skip_relocation, mojave:        "b26187e10d9c9648b373065d01e03a5674e65fd177408d42e833cdd2f0c7701a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70ce787fa0e398cfd5df85e6258b3ddf0c059ef13baf8d15c9c8764b8f4b2e90"
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
