class DockerSlim < Formula
  desc "Minify and secure Docker images"
  homepage "https://dockersl.im"
  url "https://github.com/docker-slim/docker-slim/archive/1.37.4.tar.gz"
  sha256 "380239e1ac484ce168c9716868101e3fb02eded389f10c4b9078175e047dc64c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "873e3bcbe01bda68937b930e569e75cb44e82c88fdaadcdd5d4186da29ac8998"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "873e3bcbe01bda68937b930e569e75cb44e82c88fdaadcdd5d4186da29ac8998"
    sha256 cellar: :any_skip_relocation, monterey:       "df87009035951ec38e0ea41d9e16bd50380270eed26b218dbce04cabde178372"
    sha256 cellar: :any_skip_relocation, big_sur:        "df87009035951ec38e0ea41d9e16bd50380270eed26b218dbce04cabde178372"
    sha256 cellar: :any_skip_relocation, catalina:       "df87009035951ec38e0ea41d9e16bd50380270eed26b218dbce04cabde178372"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19f2f87b66b944d5e7aa4ba66de5bbbe159494c3bc99dc5caaeda7dbaa4619f6"
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
