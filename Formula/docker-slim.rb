class DockerSlim < Formula
  desc "Minify and secure Docker images"
  homepage "https://dockersl.im"
  url "https://github.com/docker-slim/docker-slim/archive/1.26.1.tar.gz"
  sha256 "f3decf77b6a75cadd194085892469391cf39f7e54bf83d9ed9080308ec2d603a"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c3287964ff0aa01af0b14d6474fd3bc087972d29c587402314b267a2c9b2512" => :catalina
    sha256 "5c3287964ff0aa01af0b14d6474fd3bc087972d29c587402314b267a2c9b2512" => :mojave
    sha256 "5c3287964ff0aa01af0b14d6474fd3bc087972d29c587402314b267a2c9b2512" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X github.com/docker-slim/docker-slim/pkg/version.appVersionTag=#{version}"
    system "go", "build", "-trimpath", "-ldflags=#{ldflags}", "-o", bin/name, "./cmd/docker-slim"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-slim --version")
  end
end
