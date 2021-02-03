class DockerSlim < Formula
  desc "Minify and secure Docker images"
  homepage "https://dockersl.im"
  url "https://github.com/docker-slim/docker-slim/archive/1.34.0.tar.gz"
  sha256 "50ddf043c75e751d2c1af8eb55d8cb5b5526f3ab963c3e98a48234a77d53d926"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "237535c9cc2976f24682b9af7e0f1db5fe886eaa6d2d55af6c98a37d6bd92846"
    sha256 cellar: :any_skip_relocation, big_sur:       "be160f91ead9762101264633649a1347b2b0d6e2903d66499c6907c04f606fd1"
    sha256 cellar: :any_skip_relocation, catalina:      "096bb59fd3bd0fbecd37737df3803a66d133782b7232ab675a55788678ef4401"
    sha256 cellar: :any_skip_relocation, mojave:        "a1ff455745148a47ab3de9afab9dbdabed0ce807bf01eccd85ef8798ea28fa53"
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
