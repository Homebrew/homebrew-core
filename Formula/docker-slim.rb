class DockerSlim < Formula
  desc "Minify and secure Docker images"
  homepage "https://slimtoolkit.org/"
  url "https://github.com/slimtoolkit/slim/archive/refs/tags/1.40.1.tar.gz"
  sha256 "17210ea3448a690da1013ab6b9014c57ed31c64042c84a0e325178658342e2cf"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c220b3406f13fb076ccc9623f9ba41694b9398cf4a5828ddab35183fd2f656f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c220b3406f13fb076ccc9623f9ba41694b9398cf4a5828ddab35183fd2f656f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c220b3406f13fb076ccc9623f9ba41694b9398cf4a5828ddab35183fd2f656f"
    sha256 cellar: :any_skip_relocation, ventura:        "7244351ad6c6e77b66cbcf54b07bbfd56b3af51fa963754f2c729217015c679e"
    sha256 cellar: :any_skip_relocation, monterey:       "7244351ad6c6e77b66cbcf54b07bbfd56b3af51fa963754f2c729217015c679e"
    sha256 cellar: :any_skip_relocation, big_sur:        "7244351ad6c6e77b66cbcf54b07bbfd56b3af51fa963754f2c729217015c679e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4be7188b9a761bd8c1f3de061a047f11108a86fc5df882e3d5a402bf1d5852ec"
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
