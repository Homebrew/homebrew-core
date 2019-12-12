class DockerSlim < Formula
  desc "Minify and secure Docker images"
  homepage "https://dockersl.im"
  url "https://github.com/docker-slim/docker-slim/archive/1.26.1.tar.gz"
  sha256 "f3decf77b6a75cadd194085892469391cf39f7e54bf83d9ed9080308ec2d603a"

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
