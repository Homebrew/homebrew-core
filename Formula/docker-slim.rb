class DockerSlim < Formula
  desc "Minify and secure Docker images"
  homepage "https://dockersl.im"
  url "https://github.com/docker-slim/docker-slim/archive/1.33.0.tar.gz"
  sha256 "62a3fde9a60db751aeac0e0343375136524b9e3264479400e3ba5cbceef107d7"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "b97e6eac8a7db740b58ab1618fd91af2aa5f715820d501c55b626d5746b0264a" => :big_sur
    sha256 "ef169d00e400702102836c161ee9f7d6ad27ba73c414bb0c69d8e2f7f55d9b61" => :catalina
    sha256 "ec342abf3ebe30a8aeb341fe4224671f4053425a59adaa1e2ea6aec514c86326" => :mojave
    sha256 "fe253796894845a4eab86bd96d89708cf3147f53d236093bfc3315a0c0840eb9" => :high_sierra
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
