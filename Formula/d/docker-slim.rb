class DockerSlim < Formula
  desc "Minify and secure Docker images"
  homepage "https://slimtoolkit.org/"
  url "https://github.com/slimtoolkit/slim/archive/refs/tags/1.40.5.tar.gz"
  sha256 "783ee1f0068292899645cfe3efe194a419d02c2a39723e587b27e273ebe83552"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f42ecf4fb49765ff8578a0d5aba38a956abb3f7aa6cdc430b8a96530763f0c07"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e63bb2e7595bc95e9ee6b261e0beaba35d87801d78cc5d8fd72c72fb8b53d3dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7cfaad733d44d40275ad8150bde33716e1ab961b8f30708cc8be3bd43ddebe2"
    sha256 cellar: :any_skip_relocation, sonoma:         "10c8f2f45d2d4c03ad356255e64fc37ee8492dacd8101865870b93c4a75ec639"
    sha256 cellar: :any_skip_relocation, ventura:        "10beb8b08c92ad47ff271ddd4a1ecbcc6e4a7eb15a4caeeaa133d2f8b3f37522"
    sha256 cellar: :any_skip_relocation, monterey:       "1ba2c3078be639ae976f3bf5cdbf9aa4f8ab70f6679473678018d24dcfe4492a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dcb618babdd58703710f6db409cd543413735ffb73491d7ed7e670fe7fba81a"
  end

  depends_on "go" => :build

  skip_clean "bin/slim-sensor"

  def install
    system "go", "generate", "./pkg/appbom"
    ldflags = "-s -w -X github.com/docker-slim/docker-slim/pkg/version.appVersionTag=#{version}"
    system "go", "build",
                 *std_go_args(output: bin/"slim", ldflags: ldflags),
                 "./cmd/slim"

    # slim-sensor is a Linux binary that is used within Docker
    # containers rather than directly on the macOS host.
    ENV["GOOS"] = "linux"
    system "go", "build",
                 *std_go_args(output: bin/"slim-sensor", ldflags: ldflags),
                 "./cmd/slim-sensor"
    (bin/"slim-sensor").chmod 0555
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slim --version")
    system "test", "-x", bin/"slim-sensor"

    (testpath/"Dockerfile").write <<~EOS
      FROM alpine
      RUN apk add --no-cache curl
    EOS

    output = shell_output("#{bin}/slim lint #{testpath}/Dockerfile")
    assert_match "Missing .dockerignore", output
    assert_match "Stage from latest tag", output
  end
end
