class DockerSlim < Formula
  desc "Minify and secure Docker images"
  homepage "https://dockersl.im"
  url "https://github.com/docker-slim/docker-slim/archive/1.36.0.tar.gz"
  sha256 "8ea468ed5cc0ad21fda26d84a1207b0deb609eec44e0989f443a23c8cefe0971"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0734172d477ea3bafa42ab4fc7ba90f0a9fe97abf08b3f06cb4e784d6593caac"
    sha256 cellar: :any_skip_relocation, big_sur:       "d25a27dc9a06bc2ebf6c8eaa17411b30703350e9be3e83676af9c44b63568241"
    sha256 cellar: :any_skip_relocation, catalina:      "d25a27dc9a06bc2ebf6c8eaa17411b30703350e9be3e83676af9c44b63568241"
    sha256 cellar: :any_skip_relocation, mojave:        "d25a27dc9a06bc2ebf6c8eaa17411b30703350e9be3e83676af9c44b63568241"
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
