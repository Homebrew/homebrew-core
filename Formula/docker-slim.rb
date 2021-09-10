class DockerSlim < Formula
  desc "Minify and secure Docker images"
  homepage "https://dockersl.im"
  url "https://github.com/docker-slim/docker-slim/archive/1.36.4.tar.gz"
  sha256 "749ba64c2f21efde3480adf96284ba43a99ecd53c39deb779fa48ac329aa19c3"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "af86cf561e88d2927f3f3fbbb9f501fb808a8fe080c7fb4e120de0fecde125ff"
    sha256 cellar: :any_skip_relocation, big_sur:       "d4819178ccd0f2837b516eed0626549db89f9320eaa5c97b67fb4d8dcc84ccd3"
    sha256 cellar: :any_skip_relocation, catalina:      "d4819178ccd0f2837b516eed0626549db89f9320eaa5c97b67fb4d8dcc84ccd3"
    sha256 cellar: :any_skip_relocation, mojave:        "d4819178ccd0f2837b516eed0626549db89f9320eaa5c97b67fb4d8dcc84ccd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df8344915dcb9b3cd255b79bc9c305de0db4d909096abbd211399e208e8ad7a4"
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
