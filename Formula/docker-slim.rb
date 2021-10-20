class DockerSlim < Formula
  desc "Minify and secure Docker images"
  homepage "https://dockersl.im"
  url "https://github.com/docker-slim/docker-slim/archive/1.37.0.tar.gz"
  sha256 "b1128974a84b7c975a76a6dcde9fe9dc145b92f22e128bc2cb2aa0adfa83d2d6"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c1b5d2577d80254fa5bb8de3f4c219dded238506ab57bf7df48806e7ec509e3d"
    sha256 cellar: :any_skip_relocation, big_sur:       "a46948d51d60fb8f55fef561681b59fdb951d0bb193d7462c14d5653270b9146"
    sha256 cellar: :any_skip_relocation, catalina:      "a46948d51d60fb8f55fef561681b59fdb951d0bb193d7462c14d5653270b9146"
    sha256 cellar: :any_skip_relocation, mojave:        "a46948d51d60fb8f55fef561681b59fdb951d0bb193d7462c14d5653270b9146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ffb6383118ec3d09d37a3c1255ee3df378100377507dcad16113ae8a5b6f437"
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
