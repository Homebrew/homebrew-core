class DockerSlim < Formula
  desc "Minify and secure Docker images"
  homepage "https://slimtoolkit.org/"
  url "https://github.com/slimtoolkit/slim/archive/refs/tags/1.40.4.tar.gz"
  sha256 "92256e0ac5375949ded34381d0c4efbc580c81a7666c1cb704717f446a16bcb8"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "38e44d2d2e01293e99e012d4d23f56c1e5f4954590c912080d7d58351073f6aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5bc6c2b7de08b6fefb154e82d6615f8aac7d97681d4f600344e1495eca925433"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43a75f56feb9eeb4d4fe08c67b2b8681e2b1ef3e740b10797b8402faf4aadc06"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd14fda3a90edd27bf75513be2254b393d63c7d50733223bcf70eb3dc6ec253c"
    sha256 cellar: :any_skip_relocation, sonoma:         "afd8d4eb3bb82f762469173332be02a11a26eff4435f47ff06c41ef1dd89a7ec"
    sha256 cellar: :any_skip_relocation, ventura:        "273dac38547f1fe1b8aa8b5bedfed43e027f6601b0d269fefb94b301e7a2898d"
    sha256 cellar: :any_skip_relocation, monterey:       "e59a07ed4ca419795f9792737c529682c89b0cbd2daea8da48ed29ef4755fbfe"
    sha256 cellar: :any_skip_relocation, big_sur:        "5beed233d732562d2ea9ec217ceb729361b4db5e2991257fde2339b8c6976078"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b02912dc895352824760335f09e76923449042f57b75b0658c46482cee8e83e8"
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
