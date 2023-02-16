class DockerSlim < Formula
  desc "Minify and secure Docker images"
  homepage "https://slimtoolkit.org/"
  url "https://github.com/slimtoolkit/slim/archive/refs/tags/1.40.0.tar.gz"
  sha256 "b55a8f0b2e563223bfbe296349b84ff5ea134f1b67b6a9c0731c9d75dcdc6d6d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d8be3ce16049e510eae96af5f109c37925e9dd3813c5278b106b9493de54cc9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d8be3ce16049e510eae96af5f109c37925e9dd3813c5278b106b9493de54cc9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d8be3ce16049e510eae96af5f109c37925e9dd3813c5278b106b9493de54cc9"
    sha256 cellar: :any_skip_relocation, ventura:        "7fa0f9650448120f459e03515db7ad0c8359aafdc40aa7b0932bf78262c02ac1"
    sha256 cellar: :any_skip_relocation, monterey:       "7fa0f9650448120f459e03515db7ad0c8359aafdc40aa7b0932bf78262c02ac1"
    sha256 cellar: :any_skip_relocation, big_sur:        "7fa0f9650448120f459e03515db7ad0c8359aafdc40aa7b0932bf78262c02ac1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bfc569d78cd16f56d24d2cdc9134c4b12c5be5f4de2c32ead24d14ab1283283"
  end

  depends_on "go" => :build

  skip_clean "bin/slim-sensor"

  def install
    ENV["CGO_ENABLED"] = "0"
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
  end
end
