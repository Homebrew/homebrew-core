class DockerSlim < Formula
  desc "Minify and secure Docker images"
  homepage "https://dockersl.im"
  url "https://github.com/docker-slim/docker-slim/archive/1.37.2.tar.gz"
  sha256 "ef4a095698f195a9dfe28b4e8d553d459949a428f2eaad21d8017b4aec46019e"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb84b0b0064e7c9e3df80b53b4ca5a081857cd1aeef0c05929b05808a7285b19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb84b0b0064e7c9e3df80b53b4ca5a081857cd1aeef0c05929b05808a7285b19"
    sha256 cellar: :any_skip_relocation, monterey:       "f3c33377dd18abe3f1819e623970d69c245d3731b568ec442c3ae734ff41d349"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3c33377dd18abe3f1819e623970d69c245d3731b568ec442c3ae734ff41d349"
    sha256 cellar: :any_skip_relocation, catalina:       "f3c33377dd18abe3f1819e623970d69c245d3731b568ec442c3ae734ff41d349"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d212a80dc819345dc052fffa1c504968fc6d967a786b9d59a850c3f960000c7a"
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
