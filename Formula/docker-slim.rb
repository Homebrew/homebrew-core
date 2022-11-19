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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5530131e7cac9f143d716ac6ca15af79e0ddf10c5708a91dac293beb9e2e5ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5530131e7cac9f143d716ac6ca15af79e0ddf10c5708a91dac293beb9e2e5ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5530131e7cac9f143d716ac6ca15af79e0ddf10c5708a91dac293beb9e2e5ca"
    sha256 cellar: :any_skip_relocation, ventura:        "464cf7e58a1337d50116449112fe9965952b780917a6e71ac5e308aac3ed325e"
    sha256 cellar: :any_skip_relocation, monterey:       "8a1091c924a24f9f650cd269eb0559b14b708b121fbcbdb8b18ebe3195792ff0"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a1091c924a24f9f650cd269eb0559b14b708b121fbcbdb8b18ebe3195792ff0"
    sha256 cellar: :any_skip_relocation, catalina:       "8a1091c924a24f9f650cd269eb0559b14b708b121fbcbdb8b18ebe3195792ff0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be8390dd79bbf8b51bb493da16d9975e81cf0f55923e0db03dc90990aabb09f4"
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
