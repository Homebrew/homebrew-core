class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://github.com/tensorchord/envd/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "a37290c97fcca7a95d53f7d1bbcf9ddfd01664c75113d8e62b7c56708e7bd545"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46c259c42a75bf3c50f4b157d69d2c8b93151c2337a2a8e328ef472bf7d11256"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c4a7c93eedea05a4136e9992979e9c64713bec67aa38a44ef06747dbe73ef34"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "144c785bb5f5151830053d92680cf7afd966a74066c97eb1d2721e336e6bc15d"
    sha256 cellar: :any_skip_relocation, sonoma:        "eeca119dc63af86b5dcb6d1fdf4ba466c376e259fe21a2cd8ac1cb1a8c7d781c"
    sha256 cellar: :any_skip_relocation, ventura:       "53225d36398f6bbd01c65976d01f1f500ab3aa55512ad503860332d1d8c02070"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09df74749f213336223993d14c423a608ebcdbddf35830ff9ede7cfaaa4df8dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18b65f9da56f56f64d933376ff02b835770259cdadecb30f348738023e5d3b3b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/tensorchord/envd/pkg/version.buildDate=#{time.iso8601}
      -X github.com/tensorchord/envd/pkg/version.version=#{version}
      -X github.com/tensorchord/envd/pkg/version.gitTag=v#{version}
      -X github.com/tensorchord/envd/pkg/version.gitCommit=#{tap.user}
      -X github.com/tensorchord/envd/pkg/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/envd"
    generate_completions_from_executable(bin/"envd", "completion", "--no-install", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/envd version --short")

    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    expected = /failed to list containers: (Cannot|permission denied while trying to) connect to the Docker daemon/
    assert_match expected, shell_output("#{bin}/envd env list 2>&1", 1)
  end
end
